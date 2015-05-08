/*******************************************************************
* Copyright (c) 2010-2013 MiGraNT - DTAI.cs.kuleuven.be
* License details in the root directory of this distribution in
* the LICENSE file
********************************************************************/


#ifndef WORDGENERATION_HPP
#define WORDGENERATION_HPP

#include <vector>
#include <algorithm>

typedef std::vector<char> Alphabet;
typedef std::string Word;
typedef std::vector<std::size_t> Indices;

void incrementIndices(Indices & idx, std::size_t alphabetSize);
bool atEnd(const Indices & idx);
Word generateWord(const Indices & idx, const Alphabet & alphabet);

std::vector<Word> generateWords(const Alphabet & alphabet, std::size_t wordSize)
{
    std::vector<Word> words;
    Indices idx(wordSize, 0);

    do
    {
        words.push_back(generateWord(idx, alphabet));
        incrementIndices(idx, alphabet.size());
    }
    while(!atEnd(idx));

    return words;
}


Word generateWord(const Indices & idx, const Alphabet & alphabet)
{
    Word word(idx.size(), char());
    std::transform(
                idx.begin(),
                idx.end(),
                word.begin(),
                [&alphabet](std::size_t i) { return alphabet[i]; }
    );
    return word;
}



void incrementIndices(Indices & indices, std::size_t maxSize)
{
    // increment the first position
    std::size_t pos = 0;
    do
    {
        ++indices[pos];
        if(indices[pos] != maxSize)
            return;

        indices[pos] = 0;
        ++pos;
    }
    while(pos < indices.size());
}

bool atEnd(const Indices & indices)
{
    return std::all_of(
                indices.begin(),
                indices.end(),
                [](std::size_t i) {return i == 0; }
                );
}

class WordGenerator
{
public:
    using result_type = Word;

    WordGenerator(const Alphabet * alphabet, std::size_t n)
        : alphabet_(alphabet),
          n_(n),
          indices_(n, 0),
          w_(generateWord(indices_, *alphabet))
    {
    }

    const result_type & currentValue() const
    {
        return w_;
    }
    void increment()
    {
        incrementIndices(indices_, alphabet_->size());
        w_ = generateWord(indices_, *alphabet_);
    }

    bool atEnd() const
    {
        return ::atEnd(indices_);
    }


private:
    const Alphabet * alphabet_;
    std::size_t n_;
    Word w_;
    Indices indices_;
};

#endif // WORDGENERATION_HPP

