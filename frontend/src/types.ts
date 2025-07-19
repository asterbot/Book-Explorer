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

export interface BookProgress{
    bookID: number,
    title: string,
    authors: string,
    page_reached: number,
    last_update: Date,
}

export interface UserLogs{
    book_title: string,
    authors: string,
    timestamp: Date,
    page_reached: number,
}
