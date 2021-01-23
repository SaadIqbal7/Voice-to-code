# Voice to code
 

Voice-to-code Collaborative code editor that lets user write python code using natural language This is a demo application that allows the user to write python code using natural language. 
User can use speech to say something like "create function greet" and the application will create a function declaration as "def greet():". 

Natural language to code is done using deep learning. A pointer generator network is trained to peform machine translation from natural language to python code. The results, as of now, are not accurate as the dataset I used to train the model was very limited. 

Before running flutter application, request.dart file change the host to the ip address of your laptop/pc:
```
host = "xxx.xxx.xxx.xxx"
```

Then move to Server directory and start python server that runs python code written in editor:
```
py server_socket.py 
```

Make sure you have the necessary python packages. 

To make inference, first download encoder and decoder weights from this link:
https://drive.google.com/drive/folders/1cEcA2wRek9NKbZ5h0dKjUJY7hfmkwv-z?usp=sharing

Copy both encoder and decoder weights in Server/model directory

Then move to Server/model directory and start python server that makes inference from model: 
```
py inference.py 
```

In order to use the collaborative feature of editor, move to Server/PusherAuth and open app.js file. Then set the host to the ip address of your laptop/pc:
```
host = "xxx.xxx.xxx.xxx" 
```

then run node.js server using: 
```
node app.js 
```

This server uses Pusher's channel API to allow collaboration between users in the same room.


![](https://github.com/SaadIqbal7/Voice-to-code/blob/main/20210111_035920.jpg)
![](https://github.com/SaadIqbal7/Voice-to-code/blob/main/20210111_035937.jpg)
![](https://github.com/SaadIqbal7/Voice-to-code/blob/main/20210111_040030.jpg)
![](https://github.com/SaadIqbal7/Voice-to-code/blob/main/20210111_040053.jpg)
![](https://github.com/SaadIqbal7/Voice-to-code/blob/main/20210111_040115.jpg)

