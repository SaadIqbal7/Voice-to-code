import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';

class PusherApi {
	Event lastEvent;
	String lastConnectionState;
	Channel channel;

	Future<void> initPusher() async {
		try {
			Pusher.init(
				'1519c9650f1f906fbf2a',
				PusherOptions(
					cluster: 'ap2',
          auth: PusherAuth(
            'http://192.168.10.4:5000/pusher/auth'
          )
				),
				enableLogging: true,
			);
		} on PlatformException catch (e) {
			print(e.message);
		}
	}

	void connectPusher() {
		Pusher.connect(
			onConnectionStateChange: (ConnectionStateChange connectionState) async {
			lastConnectionState = connectionState.currentState;
      print('Connection state changed from: ' + connectionState.previousState + ' to: ' + connectionState.currentState);
		}, onError: (ConnectionError e) {
			print("Error: ${e.message}");
		});
	}

	// Subscribe to channel
	Future<Channel> subsribeToChannel(String roomKey) async {
		this.channel = await Pusher.subscribe('private-' + roomKey);
		return channel;
	}

	void bindEvent(String eventName, Function callback) {
		channel.bind(eventName, (last) {
			final String data = last.data;
      callback(data);
		});
	}

	void triggerEvent(String eventName, String data) {
		channel.trigger(eventName, data: data);
	}

	Future<void> firePusher() async {
		await initPusher();
		connectPusher();
	}
}
