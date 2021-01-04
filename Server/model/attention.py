import tensorflow as tf

class Attention(tf.keras.Model):
    def __init__(self, units):
        super(Attention, self).__init__()
        self.W1 = tf.keras.layers.Dense(units)
        self.W2 = tf.keras.layers.Dense(units)
        self.V = tf.keras.layers.Dense(1)

    def call(self, activations, s_prev):
        # activations (batch size, max_inp_length, enc_units)
        # s_prev (batch size, dec_units)

        # Add a dimension to s_prev
        s_prev = tf.expand_dims(s_prev, 1)  # (batch size, 1, dec_units)
        w1 = self.W1(activations)  # (batch size, max_inp_length, units)
        w2 = self.W2(s_prev)  # (batch size, 1, units)
        # (batch size, max_inp_length, units)
        self.score = self.V(tf.nn.tanh(w1 + w2))

        # (batch size, max_inp_length, 1)
        attention_weights = tf.nn.softmax(self.score, axis=1)
        # (batch size, max_inp_length, enc_units)
        context = attention_weights * activations
        context = tf.reduce_sum(context, axis=1)  # (batch size, enc_units)

        return context, attention_weights
