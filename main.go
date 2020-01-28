package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

const TODO_NUM = 20

func initMockTodos() []*Todo {
	todos := make([]*Todo, 0)
	for i := 0; i < TODO_NUM; i++ {
		now := time.Now()
		todos = append(todos, &Todo{
			ID:          uint(i + 1),
			Title:       fmt.Sprintf("Title %d", i),
			Description: fmt.Sprintf("Description %d", i),
			CreatedAt:   now,
			UpdatedAt:   now,
			ExpiresAt:   now.AddDate(0, 0, i),
		})
	}
	return todos
}

func MockTodoMiddleware(c *gin.Context) {
	todos := initMockTodos()
	c.Set("total_todos", len(todos))
}

func main() {
	r := gin.Default()
	r.Use(MockTodoMiddleware)
	r.GET("/ping", func(c *gin.Context) {

		c.JSON(http.StatusOK, gin.H{
			"message":     "pong",
			"total_todos": c.GetInt("total_todos"),
		})
	})
	r.GET("/pong", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message":     "ping",
			"total_todos": c.GetInt("total_todos"),
		})
	})
	r.Run()
}
