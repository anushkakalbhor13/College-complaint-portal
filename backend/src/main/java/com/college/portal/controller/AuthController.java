package com.college.portal.controller;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@Validated
public class AuthController {

    private final JdbcTemplate jdbcTemplate;
    private final com.college.portal.security.JwtUtil jwtUtil;

    public AuthController(JdbcTemplate jdbcTemplate, com.college.portal.security.JwtUtil jwtUtil) {
        this.jdbcTemplate = jdbcTemplate;
        this.jwtUtil = jwtUtil;
    }

    public record RegisterRequest(
            @NotBlank @Size(max = 100) String name,
            @NotBlank @Email String email,
            @NotBlank @Size(min = 6, max = 100) String password,
            @NotBlank String role
    ) {}

    public record LoginRequest(
            @NotBlank @Email String email,
            @NotBlank String password,
            @NotBlank String role
    ) {}

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody @Validated RegisterRequest req) {
        // Normalize role
        String role = req.role().toLowerCase();
        if (!(role.equals("student") || role.equals("admin") || role.equals("official"))) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Invalid role"));
        }

        Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM users WHERE email = ?",
                Integer.class, req.email());
        if (exists != null && exists > 0) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("error", "Email already registered"));
        }

        String hash = BCrypt.hashpw(req.password(), BCrypt.gensalt());
        KeyHolder keyHolder = new GeneratedKeyHolder();
        int updated = jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users (name, email, password, role) VALUES (?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, req.name());
            ps.setString(2, req.email());
            ps.setString(3, hash);
            ps.setString(4, role);
            return ps;
        }, keyHolder);

        if (updated > 0) {
            Number id = keyHolder.getKey();
            return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
                    "id", id,
                    "name", req.name(),
                    "email", req.email(),
                    "role", role
            ));
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Registration failed"));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Validated LoginRequest req) {
        try {
            Map<String, Object> row = jdbcTemplate.queryForMap(
                    "SELECT id, name, email, password, role FROM users WHERE email = ? AND role = ?",
                    req.email(), req.role().toLowerCase());
            String hash = (String) row.get("password");
            if (BCrypt.checkpw(req.password(), hash)) {
                Long id = ((Number) row.get("id")).longValue();
                String token = jwtUtil.createToken(id, (String) row.get("email"), (String) row.get("role"));
                return ResponseEntity.ok(Map.of(
                        "token", token,
                        "user", Map.of(
                                "id", id,
                                "name", row.get("name"),
                                "email", row.get("email"),
                                "role", row.get("role")
                        )
                ));
            }
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Invalid credentials"));
        } catch (EmptyResultDataAccessException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Invalid credentials"));
        }
    }
}
