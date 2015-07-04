(function() {
  var availableParts, character, checkCreativity, getRandomParts, randint, resetParts, submit, totalWeight, weight,
    hasProp = {}.hasOwnProperty;

  availableParts = {
    "一": 11006,
    "口": 8040,
    "十": 4399,
    "ノ": 3334,
    "木": 2270,
    "丶": 1792,
    "八": 1420,
    "艹": 1386,
    "⺡": 1200,
    "大": 985,
    "𠆢": 887,
    "⺅": 845,
    "月": 823,
    "又": 801,
    "⺘": 764,
    "女": 754,
    "儿": 725,
    "金": 721,
    "火": 712,
    "宀": 709,
    "ク": 657,
    "亠": 646,
    "糸": 598,
    "虫": 585,
    "山": 568,
    "灬": 521,
    "言": 509,
    "勹": 505,
    "厶": 498,
    "冖": 487,
    "冂": 484,
    "心": 475,
    "⻖": 441,
    "人": 431,
    "⺖": 416,
    "⺮": 409,
    "夂": 390,
    "尸": 383,
    "石": 373,
    "寸": 361,
    "隹": 360,
    "攵": 359,
    "辶": 350,
    "鳥": 329,
    "力": 318,
    "⺉": 315,
    "厂": 313,
    "皿": 291,
    "艮": 290,
    "立": 286,
    "广": 282,
    "夕": 278,
    "匕": 265,
    "車": 264,
    "耳": 262,
    "刀": 261,
    "子": 255,
    "几": 255,
    "巾": 254,
    "工": 245,
    "足": 241,
    "疒": 234,
    "止": 234,
    "丁": 232,
    "衤": 228,
    "馬": 224,
    "方": 221,
    "⺨": 216,
    "小": 210,
    "羽": 208,
    "雨": 205,
    "門": 205,
    "⺫": 200,
    "彳": 198,
    "䒑": 197,
    "廾": 197,
    "戈": 195,
    "彡": 192,
    "酉": 188,
    "匚": 187,
    "斤": 186,
    "虍": 182,
    "欠": 182,
    "弓": 164,
    "幺": 156,
    "爫": 150,
    "龷": 140,
    "示": 138,
    "⺊": 137,
    "㐅": 134,
    "冫": 132,
    "西": 132,
    "豕": 126,
    "㔾": 125,
    "⺌": 124,
    "衣": 122,
    "ネ": 121,
    "⺧": 119,
    "革": 118,
    "丂": 116
  };

  totalWeight = 0;

  for (character in availableParts) {
    weight = availableParts[character];
    totalWeight += weight;
  }

  $.get('data.json', function(data) {
    var tokens;
    for (character in data) {
      if (!hasProp.call(data, character)) continue;
      tokens = data[character];
      tokens.sort();
    }
    window.data = data;
    return $(document).ready(function() {
      resetParts();
      $('.kanji-part').click(function() {
        $(this).toggleClass('active');
        return checkCreativity();
      });
      return $('.go').click(function() {
        return submit();
      });
    });
  });

  randint = function(lower, upper) {
    var ref, ref1;
    if (upper == null) {
      ref = [0, lower], lower = ref[0], upper = ref[1];
    }
    if (lower > upper) {
      ref1 = [upper, lower], lower = ref1[0], upper = ref1[1];
    }
    return Math.floor(Math.random() * (upper - lower) + lower);
  };

  getRandomParts = function() {
    var level;
    level = randint(totalWeight);
    for (character in availableParts) {
      weight = availableParts[character];
      level -= weight;
      if (level < 0) {
        return character;
      }
    }
  };

  resetParts = function(ids) {
    var i, id, len, part, results;
    if (ids == null) {
      ids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
    }
    results = [];
    for (i = 0, len = ids.length; i < len; i++) {
      id = ids[i];
      part = getRandomParts();
      results.push($('.kanji-part').eq(id).text(part).removeClass('active'));
    }
    return results;
  };

  submit = function() {
    var hit;
    hit = checkCreativity();
    if (hit !== null) {
      $('.generated-kanjies').append(hit);
      resetParts([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15].filter(function(index) {
        return $('.kanji-part').eq(index).hasClass('active');
      }));
      return $('.go').removeClass('active');
    }
  };

  checkCreativity = function() {
    var parts, partsSize, ref, tokens;
    $('.go').removeClass('active');
    parts = $('.kanji-part.active').map(function() {
      return $(this).text();
    }).toArray();
    if (parts.length <= 1) {
      return;
    }
    partsSize = parts.length;
    parts.sort();
    ref = window.data;
    for (character in ref) {
      if (!hasProp.call(ref, character)) continue;
      tokens = ref[character];
      if (tokens.length !== partsSize) {
        continue;
      }
      if (parts.every(function(part, index) {
        return tokens[index] === part;
      })) {
        $('.go').addClass('active');
        return character;
      }
    }
    return null;
  };

}).call(this);
