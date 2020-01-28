package main

import "time"

// Todo represents a single ToDo item
type Todo struct {
	ID          uint `json:"id"`
	Title       string
	Description string
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   time.Time
	ExpiresAt   time.Time
}
