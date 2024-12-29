import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Get API URL from window object (set by config.js) or fall back to current host
  const API_URL = window.REACT_APP_API_URL || window.location.origin;
  console.log('Using API URL:', API_URL); // Debug log

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    try {
      console.log('Fetching tasks from:', `${API_URL}/api/tasks`);
      const response = await fetch(`${API_URL}/api/tasks`, {
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'omit' // Disable sending credentials
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      console.log('Received tasks:', data); // Debug log
      setTasks(data);
      setLoading(false);
    } catch (err) {
      console.error('Error fetching tasks:', err);
      setError(`Failed to fetch tasks: ${err.message}`);
      setLoading(false);
    }
  };

  const addTask = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${API_URL}/api/tasks`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        credentials: 'omit', // Disable sending credentials
        body: JSON.stringify({ title: newTask }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setTasks([...tasks, data]);
      setNewTask('');
    } catch (err) {
      console.error('Error adding task:', err);
      setError(`Failed to add task: ${err.message}`);
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className="App">
      <h1>Task Manager</h1>
      <form onSubmit={addTask}>
        <input
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Enter a new task"
        />
        <button type="submit">Add Task</button>
      </form>
      <ul>
        {tasks.map((task) => (
          <li key={task._id}>{task.title}</li>
        ))}
      </ul>
    </div>
  );
}

export default App; 