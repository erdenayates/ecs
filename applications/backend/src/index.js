const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Task = require('./models/task');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB connection
const MONGODB_URI = process.env.MONGODB_URI;
console.log('Attempting to connect to MongoDB with URI:', MONGODB_URI);

mongoose.connect(MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  ssl: false,
  directConnection: true,
  retryWrites: false
}).then(() => {
  console.log('Connected to DocumentDB');
}).catch((error) => {
  console.error('Error connecting to DocumentDB:', error);
  console.error('Error details:', error.message);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Routes
app.get('/tasks', async (req, res) => {
  try {
    console.log('Fetching tasks...');
    const tasks = await Task.find();
    console.log('Found tasks:', tasks);
    res.json(tasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ error: 'Error fetching tasks', details: error.message });
  }
});

app.post('/tasks', async (req, res) => {
  try {
    console.log('Received task creation request:', req.body);
    const task = new Task(req.body);
    console.log('Created task object:', task);
    const savedTask = await task.save();
    console.log('Saved task:', savedTask);
    res.status(201).json(savedTask);
  } catch (error) {
    console.error('Error creating task:', error);
    res.status(400).json({ error: 'Error creating task', details: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
}); 