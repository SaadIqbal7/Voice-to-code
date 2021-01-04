from vocabulary import PAD
from vocabulary import START
from vocabulary import END
import vocabulary


class Example:
	'''Class to preprocess the source and target sent, and generate the encoder and decoder sequence'''
	def __init__(self, source_sent, target_sent, source_vocab, target_vocab, source_max_len, target_max_len):
		'''
			Args:
				source_sent: the source sentence (string)
				target_sent: the target_sentence (string)
				source_vocab: the source vocab
				target_vocab: the target vocab
		'''
		# Store the preprocessed source sentence
		self.preprocessed_enc_input = str(source_sent).lower().strip()
		# Store the input to the encoder

		self.enc_input, self.source_oov_words, self.enc_pad_mask = self.get_enc_input(
			source_max_len, source_vocab, target_vocab)

		# Store the preprocessed target sentence
		if target_sent == '':
			self.preprocessed_dec_input = target_vocab.index_word[2]
			self.dec_input = target_vocab.word_index[START]
		else:
			self.preprocessed_dec_input = START + ' ' + str(target_sent).strip() + ' ' + END
			self.dec_input, self.dec_pad_mask = self.get_dec_input(
				target_max_len, source_vocab, target_vocab)


	def get_enc_input(self, source_max_len, source_vocab, target_vocab):
		'''Get the tokenized input to encoder'''
		source_indices, oov_words = vocabulary.source2id(
			self.preprocessed_enc_input, source_vocab)
		
		src_len = len(source_indices)
		# Pad the enc_input till the max length
		for _ in range(src_len, source_max_len):
			source_indices.append(source_vocab.word_index[PAD])

		# Generate encoder pad mask
		enc_pad_mask = []
		for _ in range(0, src_len):
			enc_pad_mask.append(1)
		
		for _ in range(src_len, source_max_len):
			enc_pad_mask.append(0)

		return source_indices, oov_words, enc_pad_mask

	def get_dec_input(self, target_max_len, source_vocab, target_vocab):
		'''Get the input to decoder'''
		dec_input = vocabulary.target2id(self.preprocessed_dec_input, target_vocab, source_vocab, self.source_oov_words)

		targ_len = len(dec_input)
		# Pad till max length (-2 is for excluding the count of START and END tokens)
		for _ in range(targ_len - 2, target_max_len):
			dec_input.append(target_vocab.word_index[PAD])

		# Generate encoder pad mask
		dec_pad_mask = []
		for _ in range(0, targ_len):
			dec_pad_mask.append(1)
		
		for _ in range(targ_len - 2, target_max_len):
			dec_pad_mask.append(0)
		
		return dec_input, dec_pad_mask
