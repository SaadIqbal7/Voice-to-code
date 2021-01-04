import tensorflow as tf

class Encoder(tf.keras.Model):
    def __init__(self, enc_units, emb_dims, src_vocab_size):
        super(Encoder, self).__init__()

        # Define lstm
        self.lstm1 = tf.keras.layers.Bidirectional(
            tf.keras.layers.LSTM(
                enc_units, return_sequences=True, recurrent_initializer='glorot_uniform'))
        self.lstm2 = tf.keras.layers.Bidirectional(
            tf.keras.layers.LSTM(
                enc_units, return_sequences=True, recurrent_initializer='glorot_uniform'))

        self.src_embedding = tf.keras.layers.Embedding(
            src_vocab_size + 1, emb_dims)

    def call(self, x):
        # x: (batch_size, max_inp_len) np.ndarray

        x = tf.convert_to_tensor(x)

        # (batch size, max_inp_len, emb_dims)
        embeddings = self.src_embedding(x)

        # Pass through the LSTM cell
        # (batch size, max_inp_len, enc_units)
        activations = self.lstm1(embeddings)
        # (batch size, max_inp_len, enc_units)
        activations = self.lstm2(activations)

        return activations
