package com.college.portal.controller;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/complaints")
@Validated
public class ComplaintController {

    private final JdbcTemplate jdbcTemplate;
    private final com.college.portal.security.JwtUtil jwtUtil;

    public ComplaintController(JdbcTemplate jdbcTemplate, com.college.portal.security.JwtUtil jwtUtil) {
        this.jdbcTemplate = jdbcTemplate;
        this.jwtUtil = jwtUtil;
    }

    public record CreateComplaintRequest(
            @NotBlank @Size(max = 200) String title,
            @NotBlank String description
    ) {}

    private Long requireUserId(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            throw new IllegalArgumentException("Missing Authorization header");
        }
        String token = authorization.substring("Bearer ".length());
        var claims = jwtUtil.parse(token);
        return Long.valueOf(claims.getSubject());
    }

    @PostMapping
    public ResponseEntity<?> createComplaint(@RequestHeader(name = "Authorization", required = true) String authorization,
                                             @RequestBody @Validated CreateComplaintRequest req) {
        Long userId = requireUserId(authorization);
        // Basic validation: ensure user exists
        Integer exists = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE id = ?", Integer.class, userId);
        if (exists == null || exists == 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Invalid user"));
        }
        KeyHolder keyHolder = new GeneratedKeyHolder();
        int updated = jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO complaints (user_id, title, description) VALUES (?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, userId);
            ps.setString(2, req.title());
            ps.setString(3, req.description());
            return ps;
        }, keyHolder);
        if (updated > 0) {
            Number id = keyHolder.getKey();
            return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id", id, "status", "pending"));
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Failed to create complaint"));
    }

    @GetMapping
    public ResponseEntity<?> listByUser(@RequestHeader(name = "Authorization", required = true) String authorization) {
        Long userId = requireUserId(authorization);
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, title, description, status, created_at FROM complaints WHERE user_id = ? ORDER BY created_at DESC",
                userId);
        return ResponseEntity.ok(rows);
    }
}
