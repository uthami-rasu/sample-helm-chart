package com.softqa.helm.controller;

import com.softqa.helm.model.Task;
import com.softqa.helm.model.User;
import com.softqa.helm.payload.request.TaskRequest;
import com.softqa.helm.payload.response.MessageResponse;
import com.softqa.helm.repository.TaskRepository;
import com.softqa.helm.repository.UserRepository;
import com.softqa.helm.security.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    @Autowired
    TaskRepository taskRepository;

    @Autowired
    UserRepository userRepository;

    private User getCurrentUser() {
        UserDetailsImpl userDetails = (UserDetailsImpl) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userRepository.findById(userDetails.getId()).orElseThrow();
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return taskRepository.findByUser(getCurrentUser());
    }

    @PostMapping
    public Task createTask(@RequestBody TaskRequest taskRequest) {
        Task task = Task.builder()
                .title(taskRequest.getTitle())
                .description(taskRequest.getDescription())
                .isCompleted(false)
                .user(getCurrentUser())
                .build();
        return taskRepository.save(task);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateTask(@PathVariable Long id, @RequestBody TaskRequest taskRequest) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Error: Task not found."));

        // Verify ownership
        Long ownerId = task.getUser().getId();
        Long currentUserId = getCurrentUser().getId();
        
        System.out.println("Debug (Update): Task owner ID: " + ownerId + ", Current User ID: " + currentUserId);

        if (!ownerId.equals(currentUserId)) {
            return ResponseEntity.status(403).body(new MessageResponse("Error: Unauthorized access."));
        }

        task.setTitle(taskRequest.getTitle());
        task.setDescription(taskRequest.getDescription());
        if (taskRequest.getIsCompleted() != null) {
            task.setCompleted(taskRequest.getIsCompleted());
        }

        taskRepository.save(task);
        return ResponseEntity.ok(task);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Error: Task not found."));

        // Verify ownership
        if (!task.getUser().getId().equals(getCurrentUser().getId())) {
            return ResponseEntity.status(403).body(new MessageResponse("Error: Unauthorized access."));
        }

        taskRepository.delete(task);
        return ResponseEntity.ok(new MessageResponse("Task deleted successfully!"));
    }

    @PatchMapping("/{id}/toggle")
    public ResponseEntity<?> toggleTask(@PathVariable Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Error: Task not found."));

        // Verify ownership
        Long ownerId = task.getUser().getId();
        Long currentUserId = getCurrentUser().getId();
        
        System.out.println("Debug: Task owner ID: " + ownerId + ", Current User ID: " + currentUserId);

        if (!ownerId.equals(currentUserId)) {
            return ResponseEntity.status(403).body(new MessageResponse("Error: Unauthorized access."));
        }

        task.setCompleted(!task.isCompleted());
        taskRepository.save(task);
        return ResponseEntity.ok(task);
    }
}
