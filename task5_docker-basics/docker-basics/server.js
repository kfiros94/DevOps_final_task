const express = require('express')
const app = express();

app.get('/', (req, res) => {
    res.send('The arcade is packed with retro games 🎮🕹️👾')
});

const port = 3000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});