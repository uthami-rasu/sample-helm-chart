package com.softqa.helm.payload.request;

import lombok.Data;

@Data
public class TaskRequest {
    private String title;
    private String description;
    private Boolean isCompleted;
}
