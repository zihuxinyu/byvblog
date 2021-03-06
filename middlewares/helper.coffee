util = require 'util'
config = require '../config'
zhsMsg = require '../locale/zhs'
zhtMsg = require '../locale/zht'
dateFormat = require('dateformat')

monthText = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']

module.exports = (req, res, next) ->
  res.locals.dateFormat = dateFormat
  res.locals.inspect = util.inspect
  res.locals.session = req.session
  
  pathSec = req._parsedUrl.pathname.split '/'
  #Remove language
  if pathSec[1] in config.languages
    pathStart = 2
    language = pathSec[1]
  else
    pathStart = 1
    language = null
  pathSec = pathSec.slice(pathStart)
  #Remove page
  if pathSec.length >= 2 and pathSec[pathSec.length - 2] is 'page'
    pathSec = pathSec.slice(0, pathSec.length - 2)
  postId = '/' + pathSec.join '/'

  res.locals.postId = postId
  res.locals.language = language
  
  res.locals.success = ->
    success = req.session.success
    req.session.success = undefined
    success
  res.locals.errors = ->
    error = req.session.error
    req.session.error = undefined
    error
  
  res.locals.langLink = (suffix) ->
    suffix = '/' + language + suffix if (language)
    suffix
  
  res.locals.postTitle = (post) ->
    for content in post.contents
      if content.language is language
        return content.title
    post.contents[0].title
  
  res.locals.label = (text) ->
    if language is 'zht' or not language
      label = zhtMsg[text.toLowerCase()]
    else if language is 'zhs'
      label = zhsMsg[text.toLowerCase()]
    if not label?
      label = text
    label
  
  res.locals.monthText = (date) ->
    if language is 'en'
      text = dateFormat(date, 'mmmm')
    else
      text = monthText[date.getMonth()]
    text
  
  res.locals.monthYearText = (date) ->
    if language is 'en'
      text = dateFormat(date, 'mmmm yyyy')
    else
      text = date.getFullYear() + '年' + monthText[date.getMonth()]
    text
  
  res.locals.dateText = (date) ->
    if language is 'en'
      text = dateFormat(date, 'mmmm dd yyyy')
    else
      text = date.getFullYear() + '年' + (date.getMonth() + 1) + '月' + date.getDate() + '日'
    text

  next()
