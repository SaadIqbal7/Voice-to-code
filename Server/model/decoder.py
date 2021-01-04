import tensorflow as tf
from pgen import PGen
from attention import Attention

class Decoder(tf.keras.Model):
    def __init__(self, dec_units, emb_dims, target_vocab_size):
        super(Decoder, self).__init__()
        self.dec_units = dec_units

        self.target_embedding = tf.keras.layers.Embedding(target_vocab_size + 1, emb_dims)
        # Define LSTM cell
        self.lstm = tf.keras.layers.LSTM(dec_units, return_state=True, recurrent_initializer='glorot_uniform')

        self.fc = tf.keras.layers.Dense(target_vocab_size)

        self.attention = Attention(dec_units)

        self.pgen = PGen(dec_units)

    def call(self, x, activations, dec_hidden, dec_cell):
        # x: (batch size, 1)
        # activations: (batch size, max_inp_length, enc_units)
        # dec_hidden: (batch size, dec_units)
        # dec_cell: (batch size, dec_units)

        # Get context vector (batch size, enc_units) and attention weights (batch size, max_inp_length, 1)
        context, attention_weights = self.attention(activations, dec_hidden)

        # Get embeddings
        x = self.target_embedding(x) # (batch size, 1, emb_dims)

        # Calculate pgen
        pgen = self.pgen(tf.reshape(x, [x.shape[0], -1]), dec_hidden, context)

        # concatenate word embeddings and context vector
        # concatenate on last axis
        concat = tf.concat([tf.expand_dims(context, 1), x], axis=-1) # (batch size, 1, emb_dims + enc_units)

        # Pass through the lstm and get hidden state and cell state
        dec_hidden, _, dec_cell = self.lstm(concat, initial_state=[dec_hidden, dec_cell])

        # Get the prediction at time t
        predictions = self.fc(dec_hidden) # (batch size, target_vocab_size)

        # Softmax the predictions
        predictions = tf.nn.softmax(predictions, axis=1)

        return dec_hidden, dec_cell, predictions, tf.reshape(attention_weights, [x.shape[0], -1]), pgen

    def initialize_states(self, batch_size):
        return tf.zeros((batch_size, self.dec_units)), tf.zeros((batch_size, self.dec_units))