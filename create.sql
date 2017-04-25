CREATE TABLE Login
(
  userID INT(16) NOT NULL AUTO_INCREMENT,
  userHash VARCHAR(128) NOT NULL,
  salt VARCHAR(128) NOT NULL,
  username VARCHAR(56) NOT NULL,
  emailAddress VARCHAR(128) NOT NULL,
  PRIMARY KEY(userID)
);

CREATE TABLE ImageStore
(
  imageID INT(128) NOT NULL AUTO_INCREMENT,
  image BLOB NOT NULL,
  PRIMARY KEY(imageID)
);

CREATE TABLE Document
(
  docID INT(16) NOT NULL AUTO_INCREMENT,
  docTitle VARCHAR(56) NOT NULL,
  noPages INT(3) NOT NULL,
  dateCreated DATE NOT NULL,
  userID INT(16) NOT NULL,
  PRIMARY KEY(docID),
  FOREIGN KEY(userID) REFERENCES Login(userID)
  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ImagePage
(
  docID INT(16) NOT NULL,
  imageID INT(128) NOT NULL,
  encryptionKey CHAR(30) NOT NULL,
  pageNo INT(3) NOT NULL,
  FOREIGN KEY(docID) REFERENCES Document(docID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(imageID) REFERENCES ImageStore(imageID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY(docID, imageID)
);

CREATE TABLE Tag
(
  tagID INT(16) NOT NULL AUTO_INCREMENT,
  tag VARCHAR(56) NOT NULL,
  PRIMARY KEY(TagID)
);

CREATE TABLE TagApplication
(
  tagID INT(16) NOT NULL,
  docID INT(128) NOT NULL,
  PRIMARY KEY(tagID, docID),
  FOREIGN KEY(tagID) REFERENCES Tag(tagID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(docID) REFERENCES Document(docID)
  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TRIGGER pageIncrement AFTER INSERT ON ImagePage
FOR EACH ROW
UPDATE Document SET noPages = noPages + 1 WHERE docID = NEW.docID;

CREATE TRIGGER clearPages AFTER DELETE ON ImagePage
FOR EACH ROW
DELETE FROM ImageStore
WHERE imageID NOT IN (SELECT imageID FROM ImagePage);