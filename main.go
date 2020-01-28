package main

import (
	"errors"
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
	c.Set("todos", todos)
}

func main() {
	r := gin.Default()
	r.Use(MockTodoMiddleware)
	r.GET("/ping", func(c *gin.Context) {
		todos, ok := c.Get("todos")
		if !ok {
			c.AbortWithError(404, errors.New("No todo for your my friend"))
		}
		c.JSON(http.StatusOK, gin.H{
			"todos": todos,
		})
	})
	r.Run()
}
