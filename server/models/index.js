const db = require('../db');

module.exports = {
  // retrieveQs: (productID, query) => (
  //
  // ),
  retrieveAs: (questionID, query) => (
    db.query(
      `SELECT json_build_object(
        'question', (SELECT id from questions WHERE id=$1)::text,
        'page', $2,
        'count', $3,
        'results', (SELECT json_agg(row_to_json(answers))
          FROM (
            SELECT
              a.id AS answer_id,
              a.answer_body AS body,
              SELECT (to_char(a.answer_date, 'YYYY-MM-DD"T"HH24:MI:SS.MSZ')) AS date,
              a.answerer_name,
              a.answer_helpfulness AS helpfulness,
              json_agg(json_strip_nulls(json_build_object(
                'id', p.id,
                'url', p.url
              ))) AS photos
            FROM answers a
            LEFT JOIN photos p ON a.id = p.answer_id
            WHERE question_id=$1 AND reported=false
            GROUP BY a.id
            LIMIT $3 OFFSET $2
          ) answers
        )
      )`,
      [questionID, query.page, query.count],
    )
  ),
  postQ: (question) => (
    db.query(
      `INSERT INTO questions
      (product_id, question_body, asker_name, asker_email)
      VALUES ($1, '$2', '$3', '$4')`,
      [question.product_id, question.body, question.name, question.email],
    )
  ),
  postA: (questionID, answer) => (
    db.query(
      `INSERT INTO answers
      (question_id, answer_body, answerer_name, answerer_email)
      VALUES ($1, $2, $3, $4)`,
      [questionID, answer.body, answer.name, answer.email],
    )
      .then(() => {
        Promise.all(answer.photos.map((url) => (
          db.query(
            `INSERT INTO photos (answer_id, url)
            VALUES ((SELECT MAX(id) from answers), $1)`,
            [url],
          )
        )));
      })
      .catch((err) => err)
  ),
  putQHelpful: (questionID) => (
    db.query(
      `UPDATE questions
      SET question_helpfulness = question_helpfulness + 1
      WHERE id = $1`,
      [questionID],
    )
  ),
  putQReported: (questionID) => (
    db.query(
      `UPDATE questions
      SET reported = 1
      WHERE id = $1`,
      [questionID],
    )
  ),
  putAHelpful: (answerID) => (
    db.query(
      `UPDATE answers
      SET answer_helpfulness = answer_helpfulness + 1
      WHERE id = $1`,
      [answerID],
    )
  ),
  putAReported: (answerID) => (
    db.query(
      `UPDATE questions
      SET reported = 1
      WHERE id = $1`,
      [answerID],
    )
  ),
};
