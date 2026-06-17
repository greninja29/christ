# =============================================================
# TMS Git Workshop - Activity Setup Script (For Instructor)
# =============================================================
# Run this BEFORE the session to prepare the repo with
# conflicting changes that students will need to resolve.
# =============================================================

# STEP 1: Initialize the repo and make initial commits
cd tms-git-workshop
git init
git add .
git commit -m "feat: initial Spring Boot project setup"

# STEP 2: Create a "simulate-main-updates" branch
# This branch contains changes that will conflict with student work

git checkout -b simulate-main-updates

# --- Conflicting change 1: Modify UserController.java ---
# Add a search endpoint that conflicts with what students will add

cat > src/main/java/com/tms/workshop/controller/UserController.java << 'EOF'
package com.tms.workshop.controller;

import com.tms.workshop.model.User;
import com.tms.workshop.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        User user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/search")
    public ResponseEntity<List<User>> searchByDepartment(@RequestParam String department) {
        List<User> users = userService.getUsersByDepartment(department);
        return ResponseEntity.ok(users);
    }

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User created = userService.createUser(user);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        User updatedUser = userService.updateUser(id, user);
        return ResponseEntity.ok(updatedUser);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
EOF

git add .
git commit -m "feat: add department search endpoint"

# --- Conflicting change 2: Modify UserService.java ---
# Add validation that conflicts with what students will add

cat > src/main/java/com/tms/workshop/service/UserService.java << 'EOF'
package com.tms.workshop.service;

import com.tms.workshop.model.User;
import com.tms.workshop.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    public List<User> getUsersByDepartment(String department) {
        if (department == null || department.isBlank()) {
            throw new IllegalArgumentException("Department cannot be empty");
        }
        return userRepository.findByDepartment(department);
    }

    public User createUser(User user) {
        // Validate email uniqueness
        User existing = userRepository.findByEmail(user.getEmail());
        if (existing != null) {
            throw new RuntimeException("User with email already exists: " + user.getEmail());
        }
        return userRepository.save(user);
    }

    public User updateUser(Long id, User userDetails) {
        User user = getUserById(id);
        user.setName(userDetails.getName());
        user.setEmail(userDetails.getEmail());
        user.setDepartment(userDetails.getDepartment());
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        User user = getUserById(id);
        userRepository.delete(user);
    }
}
EOF

git add .
git commit -m "feat: add email validation and department search in service"

# STEP 3: Go back to main and note the commit
git checkout main

echo ""
echo "========================================="
echo " SETUP COMPLETE!"
echo "========================================="
echo ""
echo "The repo is ready. During the activity:"
echo "  1. Students clone this repo and work on 'main'"
echo "  2. When ready to trigger conflicts, merge simulate-main-updates into main:"
echo "     git merge simulate-main-updates"
echo "  3. Students then pull/rebase and resolve conflicts"
echo ""
