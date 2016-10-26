-- ~~~ Question 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE OR REPLACE FUNCTION insert_revision() RETURNS TRIGGER AS $$
BEGIN
  Insert into pageRevisions(name, date, author, text)
  values (new.name, now(), new.last_author, NEW.text);

  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS EditPage ON Pages;

CREATE TRIGGER EditPage INSTEAD OF INSERT OR UPDATE ON Pages
FOR EACH ROW
EXECUTE PROCEDURE insert_revision();
