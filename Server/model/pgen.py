import tensorflow as tf

class PGen(tf.keras.Model):
    def __init__(self, units):
        super(PGen, self).__init__()
        self.Wh = tf.keras.layers.Dense(units)
        self.Ws = tf.keras.layers.Dense(units)
        self.Wx = tf.keras.layers.Dense(units)
        self.pgen = tf.keras.layers.Dense(1, activation='sigmoid')

    def call(self, x, dec_hidden, context_vec):
        # x: word embedding at time t (batch size, emb_dims)
        # dec_hidden: hidden state of decoder at time t (batch size, dec_units)
        # context_vec: context vector at time t (batch size, enc_units)

        wx = self.Wx(x)  # (batch size, units)
        ws = self.Ws(dec_hidden)  # (batch size, units)
        wh = self.Wh(context_vec)  # (batch size, units)

        pgen = self.pgen(wx + ws + wh)  # (batch size, 1)

        return pgen
