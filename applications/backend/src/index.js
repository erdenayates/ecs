const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Task = require('./models/task');
const net = require('net');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB connection
const MONGODB_URI = process.env.MONGODB_URI;
console.log('Attempting to connect to MongoDB with URI:', MONGODB_URI.replace(/:([^:@]+)@/, ':****@'));

// Test TCP connection first
const testConnection = () => {
  const [host, port] = MONGODB_URI.split('@')[1].split(':');
  console.log(`Testing TCP connection to ${host}:27017`);
  
  const client = new net.Socket();
  client.setTimeout(5000);
  
  return new Promise((resolve, reject) => {
    client.on('connect', () => {
      console.log('TCP Connection successful!');
      client.destroy();
      resolve();
    });
    
    client.on('timeout', () => {
      console.log('TCP Connection timeout!');
      client.destroy();
      reject(new Error('TCP Connection timeout'));
    });
    
    client.on('error', (err) => {
      console.log('TCP Connection error:', err);
      client.destroy();
      reject(err);
    });
    
    client.connect(27017, host);
  });
};

// Wait for TCP connection before trying MongoDB
const startServer = async () => {
  try {
    await testConnection();
    
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      ssl: false,
      directConnection: true,
      retryWrites: false,
      serverSelectionTimeoutMS: 30000,
      socketTimeoutMS: 30000,
      connectTimeoutMS: 30000,
    });
    
    console.log('Connected to DocumentDB');
    
    // Start server only after DB connection
    app.listen(port, () => {
      console.log(`Server running on port ${port}`);
    });
  } catch (error) {
    console.error('Failed to connect:', error);
    process.exit(1);
  }
};

startServer();

// Add connection event listeners
mongoose.connection.on('connected', () => {
  console.log('Mongoose connected to DocumentDB');
});

mongoose.connection.on('error', (err) => {
  console.error('Mongoose connection error:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('Mongoose disconnected');
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