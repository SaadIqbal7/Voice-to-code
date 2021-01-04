var express = require('express');
var bodyParser = require('body-parser');
var cors = require('cors');
var Pusher = require('pusher');

var pusher = new Pusher({
	appId: '987702',
	key: '1519c9650f1f906fbf2a',
	secret: 'cf45867f5e96feccaac4',
	cluster: 'ap2',
});

var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());

app.get('/', (req, res) => {
	res.send('Hellow');
});

app.post('/pusher/auth', function (req, res) {
	var socketId = req.body.socket_id;
	var channel = req.body.channel_name;
	var auth = pusher.authenticate(socketId, channel);
	console.log(auth);
	res.send(auth);
});

var port = process.env.PORT || 5000;
var hostname = 'xxx.xxx.xxx.xxx'

app.listen(port, hostname, () => {
	console.log(`Server running at http://${hostname}:${port}/`);
});
