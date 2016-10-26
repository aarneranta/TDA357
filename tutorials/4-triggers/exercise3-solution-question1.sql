CREATE OR REPLACE VIEW Pages AS
SELECT name, PR1.author AS last_author, PR1.text
FROM  PageRevisions AS PR1 JOIN PageRevisions AS PR2 USING (name)
GROUP BY name, PR1.date
HAVING pr1.date = MAX(pr2.date) ;
