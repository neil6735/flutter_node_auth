const express = require("express");
const app = express();
const port = 5000;
const mongoose = require("mongoose");
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

  let user = new User({
    email,
    password,
  });
  console.log(user);

  await user.save();
  res.json({ token: "123456" });

  //check db for email, say email is already registered
  // return res.send("Signup API route");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
