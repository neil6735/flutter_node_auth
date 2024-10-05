const express = require("express");
const app = express();
const port = 5000;
const mongoose = require("mongoose");
var jwt = require("jsonwebtoken");
//db
//mongodb+srv://nemo:Ux!gQkXjYt6!wB*@cluster0.rd0kg.mongodb.net/

async function connectDB() {
  await mongoose.connect(
    "mongodb+srv://nemo:Ux!gQkXjYt6!wB*@cluster0.rd0kg.mongodb.net/"
  );
  console.log("DB connected");
}
connectDB();

//this takes the post body
app.use(express.json({ extended: false }));

app.get("/", (req, res) => {
  res.send("Hello World!");
});

//model
var schema = new mongoose.Schema({ email: "string", password: "string" });
var User = mongoose.model("User", schema);

//signup route api
app.post("/signup", async (req, res) => {
  const { email, password } = req.body;
  console.log(email);
  console.log(password);

  let user = await User.findOne({ email });
  if (user) {
    return res.json({ msg: "Email already taken" });
  }

  user = new User({
    email,
    password,
  });
  console.log(user);

  await user.save();
  var token = jwt.sign({ id: user.id }, "password");
  res.json({ token: token });

  //check db for email, say email is already registered
  // return res.send("Signup API route");
});

//login api route
app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  console.log(email);
  console.log(password);

  let user = await User.findOne({ email });
  console.log(user);
  if (!user) {
    return res.json({ msg: "No User" });
  }
  if (user.password !== password) {
    return res.json({ msg: "Incorrect Pasword" });
  }

  var token = jwt.sign({ id: user.id }, "password");
  return res.json({ token: token });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
