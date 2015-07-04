(function() {
  var availableParts, randint, resetParts, submit,
    hasProp = {}.hasOwnProperty;

  availableParts = ["一", "口", "十", "木", "ノ", "丶", "丿", "艹", "シ", "大", "八", "𠆢", "イ", "月", "又", "⺘", "女", "金", "火", "宀", "ク", "亠", "糸", "儿", "虫", "山", "灬", "言", "勹", "厶", "貝", "冖", "心", "⻖", "冂", "⺖", "⺮", "土", "夂", "人", "石", "寸", "隹", "攵", "辶", "鳥", "力", "⺉", "厂", "皿", "艮", "广", "夕", "匕", "尸", "車", "耳", "刀", "几", "子", "巾", "钅", "工", "足", "疒", "止", "丁", "衤", "馬", "方", "⺨", "小", "羽", "立", "雨", "門", "⺫", "彳", "䒑", "廾", "戈", "彡", "酉", "匚", "斤", "欠", "虍", "贝", "弓", "纟", "讠", "幺", "爫", "龷", "示", "⺊", "㐅", "冫", "西", "兀", "豕", "㔾", "⺌", "衣", "ネ", "⺧", "革", "户", "丂", "巳", "臼", "比", "戊", "舟", "巛", "マ", "龰", "辛", "毛", "二"];

  $.get('data.json', function(data) {
    var character, tokens;
    for (character in data) {
      if (!hasProp.call(data, character)) continue;
      tokens = data[character];
      tokens.sort();
    }
    window.data = data;
    return $(document).ready(function() {
      resetParts();
      $('.kanji-part').click(function() {
        return $(this).toggleClass('active');
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

  resetParts = function(ids) {
    var i, id, len, part, results;
    if (ids == null) {
      ids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    }
    results = [];
    for (i = 0, len = ids.length; i < len; i++) {
      id = ids[i];
      part = availableParts[randint(availableParts.length)];
      results.push($('.kanji-part').eq(id).text(part).removeClass('active'));
    }
    return results;
  };

  submit = function() {
    var character, hit, parts, partsSize, ref, tokens;
    parts = [];
    $('.kanji-part').each(function() {
      if ($(this).hasClass('active')) {
        return parts.push($(this).text());
      }
    });
    partsSize = parts.length;
    hit = null;
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
        hit = character;
        break;
      }
    }
    if (hit !== null) {
      $('.generated-kanjies').append(hit);
      return resetParts([0, 1, 2, 3, 4, 5, 6, 7, 8, 9].filter(function(index) {
        return $('.kanji-part').eq(index).hasClass('active');
      }));
    }
  };

}).call(this);
