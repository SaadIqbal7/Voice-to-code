#!/usr/bin/env python3
import tensorflow as tf
import numpy as np
import pandas as pd
from example import Example
from vocabulary import END
import vocabulary as vocab
from encoder import Encoder
from decoder import Decoder


def apply_attention_mask(attention_dists, enc_pad_mask):
    # attention_dist: (batch size, src_max_len)
    # enc_pad_mask: (batch size, src_max_len)
    attention_dists = tf.math.multiply(attention_dists, enc_pad_mask)

    masked_sum = tf.reduce_sum(attention_dists, axis=-1)  # (batch size,)
    # (batch size, 1)
    return attention_dists / tf.reshape(masked_sum, [-1, 1])

# Calculate final distribution using vocabulary distribution and copy distribution


def calculate_final_dist(inp, vocab_dists, copy_dists, enc_pad_mask, pgen, src_vocab_size, max_src_oov_word, ptr_net=False):
    # inp : (batch size, src_max_len)
    # vocab_dist, the predictions of one time step for the whole batch (batch size, target_vocab_size)
    # The attention for one time step for over the whole batch (batch size, src_max_len)
    if ptr_net:
        copy_dists = apply_attention_mask(copy_dists, enc_pad_mask)

        vocab_dists = tf.math.multiply(pgen, vocab_dists)
        copy_dists = tf.math.multiply((1 - pgen), copy_dists)
        # (batch size, src_vocab_size + max_src_oov_word)
        copy_dists_projected = []

        for i in range(inp.shape[0]):
            copy_dists_projected.append(
                tf.scatter_nd(
                    tf.expand_dims(inp[i, :], 1), copy_dists[i, :], [src_vocab_size + max_src_oov_word]))
        # Concatenate vocab_dist and copy dist
        # (batch size, target_vocab_size + src_vocab_size + max_src_oov_word)
        final_dists = tf.concat([vocab_dists, copy_dists_projected], axis=1)

        return final_dists
    else:
        # else final distribution is just the vocabulary distribution (Seq2Seq with Attention)
        # (batch size, target_vocab_size)
        return vocab_dists


def evaluate(inp, encoder, decoder, src_vocab, target_vocab):
    # Generate example
    ex = Example(inp, '', src_vocab, target_vocab, len(inp), 0)
    # Pass the input to the encoder
    inp = np.reshape(ex.enc_input, (1, len(ex.enc_input)))

    activations = encoder(inp)

    dec_inp = tf.expand_dims([ex.dec_input], 0)
    dec_hidden, dec_cell = decoder.initialize_states(1)

    counter = 0
    output = ''

    while counter < 20:
        dec_hidden, dec_cell, predictions, attention_weights, pgen = decoder(
            dec_inp, activations, dec_hidden, dec_cell)

        final_dist = calculate_final_dist(
            inp, predictions, attention_weights, ex.enc_pad_mask, pgen, src_vocab.vocab_size, len(ex.source_oov_words), ptr_net=True)

        prediction_idx = tf.argmax(final_dist[0]).numpy()

        if prediction_idx < target_vocab.vocab_size:

            if target_vocab.index_word[prediction_idx] == END:
                return output.strip()

            if target_vocab.index_word[prediction_idx] == '<space>':
                output += ' '
            else:
                output += target_vocab.index_word[prediction_idx]

        elif prediction_idx >= target_vocab.vocab_size and prediction_idx < (src_vocab.vocab_size + target_vocab.vocab_size):

            if src_vocab.index_word[prediction_idx - target_vocab.vocab_size] == END:
                return output.strip()

            output += src_vocab.index_word[prediction_idx - target_vocab.vocab_size]
        else:
            output += ex.source_oov_words[prediction_idx - src_vocab.vocab_size - target_vocab.vocab_size]

        counter += 1

    return output.strip()


src_vocab = vocab.Vocabulary()
target_vocab = vocab.Vocabulary()

src = np.load('src.npy', allow_pickle=True)
vocab.generate_vocab_from_text(src_vocab, src, 5000)

vocab.load_vocab_from_excel(
    target_vocab, 'Python Vocabulary.xlsx', 'Python Vocabulary.xlsx')

embedding_dim = 256
units = 1024

# Define encoder and decoder
encoder = Encoder(units, embedding_dim, src_vocab.vocab_size)
decoder = Decoder(units, embedding_dim, target_vocab.vocab_size)

encoder.load_weights('enc_weights')
decoder.load_weights('dec_weights')

