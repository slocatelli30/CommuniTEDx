const mongoose = require('mongoose');

const talk_schema = new mongoose.Schema({
    _id: String,
    slug: String,
    speakers: String,
    title: String,
    url: String,
    description: String,
    duration: String,
    tags: Array
}, { collection: 'tedx_data' });

module.exports = mongoose.model('talk', talk_schema);