export interface Book{
    bookID: number;
    title: string;
    authors: string;
    average_rating: number,
    isbn: string,
    isbn13: number,
    language_code: string,
    num_pages: number,
    ratings_count: number,
    text_reviews_count: number,
    publication_date: string,
    publisher: string
}

export type BookClub = {
  clubID: number;
  name: string;
  description: string;
  member_count: number;
};

export type ClubDetails = BookClub & {
  current_books: Book[];
  past_books: (Book & { end_date: string })[];
  members: { userID: number; name: string }[];
};