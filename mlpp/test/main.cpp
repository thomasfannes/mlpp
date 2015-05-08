#include <iostream>
#include "wordGeneration.hpp"
#include <boost/lexical_cast.hpp>

typedef std::vector<char> Alphabet;
typedef std::string Word;

void workOnWordsOfSize1(const Alphabet & a, std::size_t size)
{
    std::vector<Word> words = generateWords(a, size);
    std::size_t cnt = 0;
    for (auto w : words)
    {
        cnt += std::count(w.begin(), w.end(), 'a');
    }

    std::cout << cnt << std::endl;
}

void workOnWordsOfSize2(const Alphabet & a, std::size_t size)
{
    WordGenerator gen(&a, size);
    std::size_t cnt = 0;
    do
    {
        auto w = gen.currentValue();
        cnt += std::count(w.begin(), w.end(), 'a');

        gen.increment();
    }
    while(!gen.atEnd());

    std::cout << cnt << std::endl;
}


int main(int argc, char ** argv)
{
    std::size_t sz = 3;
    std::size_t method = 1;

    if(argc >= 3)
    {
        try
        {
            sz = boost::lexical_cast<std::size_t>(argv[1]);
            method = boost::lexical_cast<std::size_t>(argv[2]);
        }
        catch(...)
        {
        }
    }
    Alphabet a = {'a', 'b', 'c', 'd'};

    if(method == 1)
        workOnWordsOfSize1(a, sz);
    else
        workOnWordsOfSize2(a, sz);
}
