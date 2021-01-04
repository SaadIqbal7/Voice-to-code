# Tokens for unk pad start and end
import os
import numpy as np
from tensorflow.keras.preprocessing.text import Tokenizer
import pandas as pd


UNK = '<unk>'
PAD = '<pad>'
START = '<start>'
END = '<end>'


class Vocabulary:
	# vocab: a list of vocabulary
	def __init__(self, vocab=[]):
		self.word_index = {}
		self.index_word = {}
		self.vocab_size = 0
		# Word to embedding vectors
		self.word_embedding = {}

		# Insert the tokens first
		# PAD -> 0
		# UNK -> 1
		# START -> 2
		# END -> 3
		for token in PAD, UNK, START, END:
			self.word_index[token] = self.vocab_size
			self.index_word[self.vocab_size] = token
			self.vocab_size += 1

		# Load the vocabulary if it is provided
		if len(vocab) != 0:
			self.load_vocab_from_list(vocab)

	def word2id(self, word):
		'''Return id(integar) of word, return id of UNK token if word is not in vocabulary'''
		if word not in self.word_index:
			return self.word_index[UNK]
		return self.word_index[word]

	def id2word(self, id):
		'''Return the word (string) of given id, raise value error if id is not in vocabulary (oov token)'''
		if id not in self.index_word:
			raise ValueError('id %d not found in vocabulary' % id)
		return self.index_word[id]


def load_vocab_from_list(vocab: Vocabulary, vocab_list: list):
	for word in vocab_list:
		vocab.word_index[word] = vocab.vocab_size
		vocab.index_word[vocab.vocab_size] = word
		vocab.vocab_size += 1


# path_glove is the relative path to the glove vector file
# loads the word embeddings as well
def load_from_glove_vector(vocab, path_glove, load_word_embedding=True):
	print('Loading vocabulary')
	word_emb_sum = 0
	# Insert the word embeddings for start end pad and unk token
	with open(path_glove, 'r', encoding="utf8") as file:
		while True:
			line = file.readline()
			if not line:
				break
			split_line = line.split(' ')
			word = split_line[0]
			vocab.word_index[word] = vocab.vocab_size
			vocab.index_word[vocab.vocab_size] = word
			vocab.vocab_size += 1
			if load_word_embedding:
				vocab.word_embedding[word] = np.array(
					[float(value) for value in split_line[1:]])
				word_emb_sum += vocab.word_embedding[word]

		if load_word_embedding:
			# Get the length of one word embedding
			emb_length = len(vocab.word_embedding['pointer'])
			
			# Add word embeddings for PAD START END UNK
			# Word embedding for PAD is all 0s (common for PAD token)
			# Word embedding for START is all 1s (as START token is at the start of the sequence)
			# Word embedding for END is all -1s (as END token is at the end of the sequence)
			# Word embedding for UNK is the average of all normal word embeddings (words other than tokens)
			vocab.word_embedding[PAD] = np.zeros((emb_length,))
			vocab.word_embedding[START] = np.ones((emb_length,))
			vocab.word_embedding[END] = np.zeros((emb_length,)) - 1
			vocab.word_embedding[UNK] = word_emb_sum / (vocab.vocab_size - 5)

		print('Vocabulary loaded.')


# Won't include the tokens from the start
def generate_vocab_from_text(vocab, sentences, top_k=5000):
	print('Loading vocabulary...')
	tokenizer = Tokenizer(top_k, filters='', lower=False)
	tokenizer.fit_on_texts(sentences)
	pre_vocab_size = vocab.vocab_size - 1
	for word, idx in tokenizer.word_index.items():
		vocab.word_index[word] = idx + pre_vocab_size
		vocab.index_word[idx + pre_vocab_size] = word
		vocab.vocab_size += 1
	print('Vocabulary loaded.')

def load_vocab_from_excel(vocab, file_path, sheet_name):
	'''
		Reads vocabulary from excel file,
		Considers first line of excel file as the columns name (NOT an entry)
	'''
	print('Loading vocabulary...')
	vocab_df = pd.read_excel(file_path, sheet_name)
	for word in vocab_df[vocab_df.columns[0]]:
		vocab.word_index[word] = vocab.vocab_size
		vocab.index_word[vocab.vocab_size] = word
		vocab.vocab_size += 1

	print('Vocabulary loaded.')


'''	
	Convert the source sentence to indices
	The oov tokens will we be given temporary ids greater than vocab size 
	e.g if sentence has 3 oov word and the vocab size is 5000, 
	then the word will has indices as 5000, 5001 and 5002
'''
def source2id(source: str, source_vocab: Vocabulary):
	'''
		Args:\n
			source: a string of words \n
			vocab: Vocabulary object

		Returns: \n
			word_indices: list of integar indices of source words \n
			oov_words: list of oov tokens (strings) in the order they appear in the list of indices \n
	'''

	# Get the index for UNK token
	unk_index = source_vocab.word2id(UNK)
	oov_words = [] # list of oov words (strings)
	word_indices = []

	for word in source.split(' '):
		word_index = source_vocab.word2id(word) # word_index = UNK token if it is oov word
		# if oov word is encountered
		if word_index == unk_index:
			# Add word to oov words if it is already not present
			if word not in oov_words:
				# Add word to oov_word
				oov_words.append(word)
			# get the index of oov word
			oov_index = oov_words.index(word) # This is 0 for first oov_word, 1 for 2nd oov word...
			word_indices.append(source_vocab.vocab_size + oov_index)
		else:
			word_indices.append(word_index)

	return word_indices, oov_words


'''	
	Convert the target sentence to indices
	the oov words in the target sentence are not necessarily the oov words in the source sentence, 
	e.g print variable cat in source sentence maps to print ( cat ). 
	when tokenizing, cat will be present in the source vocabulary but it won't be present in the target vocabulary.
	so we need the all the words from the source sentence and check which word appears in the target sentence
'''
def target2id(target: str, target_vocab: Vocabulary, source_vocab: Vocabulary, source_oov_words:list):
	'''
		Args:
			target: string of words
			vocab: Target Vocabulary object
			source_vocab: source Vocabulary object
			source_oov_words: list of oov words (string) in the source sentence
		Returns:
			word_indices: indices of words in target sentence
	'''

	# Get the unk token id
	target_unk_id = target_vocab.word2id(UNK)

	word_indices = []

	for word in target.split(' '):
		word_id = target_vocab.word2id(word)
		# Check if oov word is encountered in target sentence
		if word_id == target_unk_id:
			# Check if the oov word in the target sentence is an oov word in the source sentence
			if word in source_oov_words:
				# Get the id of source oov word as appearing in source ids.
				# e.g if a a source oov word is at index 1 in soure_oov_words list, source_oov_word_id would be source_vocab_size + 1
				source_oov_word_id = source_vocab.vocab_size + source_oov_words.index(word)
				# Generate temporary target oov word id
				target_oov_word_id = target_vocab.vocab_size + source_oov_word_id
			else: # Else if oov word in target vocab is not an oov word in source sentence
				# Get the id of source word
				source_word_id = source_vocab.word2id(word)
				# Generate temporary target oov word id
				target_oov_word_id = target_vocab.vocab_size + source_word_id
			word_indices.append(target_oov_word_id)
		else:
			word_indices.append(word_id)

	return word_indices


'''
	Converts the id of to words from the vocabulary.
'''
def id2source(source_ids: list, source_vocab: Vocabulary, oov_words: list):
	'''
		Args:
			source_ids: list of ids (integars) of source words,
			oov_words: list of oov words (strings)
			source_vocab: source Vocabulary object

		Returns:
			source_words: list of words(string)
	'''
 
	source_words = []
	for id in source_ids:
		try:
			word = source_vocab.id2word(id) # Word can also be the <UNK> token
			# if value error is not raised, append the word to source
			source_words.append(word)
		except ValueError as e: # Value error is raised if the word is oov word (any oov word besides the <unk> token)
			# Get the word from the oov_words
			oov_word = oov_words[id - source_vocab.vocab_size]
			# Append oov word to source
			source_words.append(oov_word)
	
	return source_words

'''
	Converts the list of ids (int) to list of words(strings)
	Generate target oov words from the source sentence
'''
def id2target(target_ids:list, target_vocab:Vocabulary, source_vocab:Vocabulary, oov_words:list, ptr_net=False):
	'''
		Args:
			target_ids: list of ids (int)
			target_vocab: target Vocabulary object
			source_vocab: source Vocabulary object
			oov_words: source sentence oov_words (strings)
			ptr_net: True if working with pointer network

		Returns:
			target_words: list of words from target vocab and oov_words (strings)
	'''

	target_unk_id = target_vocab.id2word(UNK)

	target_words = []
	for id in target_ids:
		try:
			word = target_vocab.id2word(id) # Could be the <unk> token
			target_words.append(word)
		except ValueError as e: # If word is not in vocabulary, ValueError is raised
			# if ptr_net is True, Find the word in the oov_words
			if ptr_net:
				#  Check if the oov word in the target is an oov word in the source sentence as well
				# Get the source word id
				source_word_id = id - target_vocab.vocab_size
				# Check if the source word is present in the source vocab
				if source_word_id < source_vocab.vocab_size:
					# Get the source word
					source_word = source_vocab.id2word(source_word_id)
					target_words.append(source_word)
				else: # the source word id is not present in the source vocab, so source word is an oov word
					# Get the source oov word from source_oov_words
					source_oov_word_id = source_word_id - source_vocab.vocab_size
					# Get the source oov word
					target_words.append(oov_words[source_oov_word_id])
			else:
				target_words.append(target_unk_id)
