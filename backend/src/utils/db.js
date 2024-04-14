function convertObjectToFilterQuery(obj) {
    let props = Object.keys(obj);
    props = props.filter(prop => obj[prop]);
    let filterQuery = props.map((prop, index) => `${prop} = $${index + 1}`).join(" AND ");
    let args = props.map(prop => obj[prop]);
    return { filterQuery, args };
}

function convertObjectToInsertQuery(obj) {
    let props = Object.keys(obj);
    props = props.filter(prop => obj[prop]);
    let columns = props.join(", ");
    let values = props.map((_, index) => `$${index + 1}`).join(", ");
    let args = props.map(prop => obj[prop]);
    return { columns, values, args };
}

module.exports = {
    convertObjectToFilterQuery,
    convertObjectToInsertQuery
};