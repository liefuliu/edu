2 kind of users:

- Anonymous 
- Contributor
  -- Create audio
  -- Add a new book
- Administrator
  -- Delete an audio
  -- Delete a book

User Table:

<User ID>, <Security Level>, <User Attribute>

Book Table;

<Book ID>, <Book Attributes>, <Created by>

Book Audtio Table (index by book id)

<Book ID>, <Audio IDs>

Audio Table:

<Audio ID>, <Book ID>, <Created by User>


 
