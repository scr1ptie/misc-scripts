import argparse
import re
from urllib.parse import urlparse

def extract_words_from_url(url):
    parsed_url = urlparse(url)
    path_parts = parsed_url.path.split('/')
    return [part for part in path_parts if part and not re.search(r'\d', part)]

def process_urls(file_path):
    wordlist = set()

    with open(file_path, 'r') as file:
        for line in file:
            url = line.strip() 
            if url:
                words = extract_words_from_url(url)
                wordlist.update(words)

    return sorted(wordlist)

def write_wordlist_to_file(wordlist, output_file):
    with open(output_file, 'w') as file:
        for word in wordlist:
            file.write(f"{word}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract unique words from a list of URLs and create a wordlist.")
    parser.add_argument("input_file", help="File containing the list of URLs")
    parser.add_argument("-o", "--output", help="Output file to save the wordlist", default=None)
    
    args = parser.parse_args()

    wordlist = process_urls(args.input_file)

    if args.output:
        write_wordlist_to_file(wordlist, args.output)
        print(f"Wordlist saved to {args.output}")
    else:
        print("\n".join(wordlist))
