const express = require('express');
const router = express.Router();
const User = require('../models/user');
const { ObjectId } = require('mongodb');


const mongoose = require('mongoose')

const db = "mongodb://localhost:27017/users";
mongoose.Promise = global.Promise;


mongoose
  .connect(db)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("Connection error: ", err);
  });

router.get('/users', async (req, res) => {
    try {
      console.log('Get request for all');
      const us = await User.find({}).exec();
      res.json(us);
    } catch (err) {
      console.error("Error retrieving: ", err);
      res.status(500).send("Error retrieving");
    }
});

router.get('/users/:id', async (req, res) => {
    const dinoId = req.params.id;
    try {
        console.log(`Get request for user with ID: ${dinoId}`);
        const dino = await User.findById(dinoId).exec();
        if (dino) {
            res.json(dino);
        } else {
            res.status(404).send("user not found");
        }
    } catch (err) {
        console.error("Error retrieving user: ", err);
        res.status(500).send("Error retrieving user");
    }
});

router.post('/users', async (req, res) => {
    const newUser = new User({
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
    });

    try {
        console.log('Post a new user');
        const insertedDino = await newUser.save();
        insertedDino.__v = undefined;
        res.json(insertedDino);
    } catch (err) {
        console.error("Error posting user: ", err);
        res.status(500).send("Error posting user");
    }
});

router.put('/users/:id', async (req, res) => {
    console.log('Update a user');
    const dinoId = req.params.id;
    

    try {
        const updatedDino = await User.findByIdAndUpdate(
            new ObjectId(dinoId),
            {
                $set: {
                    username: req.body.username,
                    email: req.body.email,
                    password: req.body.password,
                }
            },
            {
                new: true,
            }
        );

        if (!updatedDino) {
            return res.status(404).json({ error: 'user not found' });
        }

        res.json(updatedDino);
    } catch (err) {
        console.error("Error updating user:", err);
        res.status(500).json({ error: "Error updating user" });
    }
});


router.delete('/users/:id', async (req, res) => {
    console.log('Deleting a user');
    const movieId = req.params.id;

    try {
        const deletedDino = await User.findByIdAndDelete(movieId);

        if (!deletedDino) {
            return res.status(404).json({ error: 'user not found' });
        }

        res.status(200).json({ message: 'user deleted successfully'});
    } catch (err) {
        console.error("Error deleting user:", err);
        res.status(500).json({ error: "Error deleting user" });
    }
});


module.exports = router;