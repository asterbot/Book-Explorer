import os

book_genres = [
    "Fantasy", "Science Fiction", "Mystery", "Thriller", "Romance",
    "Historical Fiction", "Horror", "Adventure", "Dystopian", "Paranormal",
    "Contemporary", "Young Adult", "New Adult", "Childrens", "Middle Grade",
    "Literary Fiction", "Magical Realism", "Urban Fantasy", "Space Opera", "Cyberpunk",
    "Steampunk", "Post-Apocalyptic", "Time Travel", "Alternate History", "Mythology",
    "Fairy Tale", "Coming of Age", "Gothic", "Crime", "Detective",
    "Psychological Thriller", "Legal Thriller", "Political Thriller", "Espionage", "Western",
    "Survival", "Epic Fantasy", "High Fantasy", "Low Fantasy", "Dark Fantasy",
    "Supernatural", "Occult", "Christian Fiction", "Inspirational", "Satire",
    "Humor", "Drama", "War", "Military Fiction", "Political Fiction",
    "Philosophical Fiction", "Science Fantasy", "Sword and Sorcery", "Hard Science Fiction", "Soft Science Fiction",
    "Biopunk", "Cli-Fi", "Noir", "Techno-thriller", "Chick Lit",
    "Domestic Fiction", "Family Saga", "Memoir", "Autobiography", "Biography",
    "True Crime", "Self-Help", "Health", "Spirituality", "Religion",
    "Travel", "Guide", "Cookbook", "Art", "Photography",
    "Poetry", "Essay", "Anthology", "Classic", "Short Stories",
    "Novella", "Graphic Novel", "Comic", "Manga", "Light Novel",
    "Educational", "Textbook", "Reference", "Journal", "Encyclopedia",
    "Dictionary", "Science", "Math", "Technology", "History",
    "Economics", "Politics", "Sociology", "Psychology", "Anthropology"
]

with open(os.path.join(os.pardir, 'genres' ,'genre.sql'), 'a') as f:
    for i in range(1, len(book_genres) + 1):
        f.write(f"({i}, '{book_genres[i-1]}'),\n")
