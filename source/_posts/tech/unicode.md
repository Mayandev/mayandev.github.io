---
title: 一次 Chrome Crash 重新认识 Unicode
date: 2022-07-24 19:30:00
tags: 
  - Unicode
  - Chrome
categories: 前端
---

在一次工作中，偶然发现一个奇特的 Bug。当 Chrome 浏览器在渲染这个一位用户的信息时，导致了浏览器的崩溃。

Bug 简单复现（MacOS）：如果你的 Chrome 版本低于 100，那么点开这个[链接](https://www.google.com.hk/search?q=%F0%9F%8D%81%E2%83%9D%F0%9F%85%B4%F0%9F%85%B5%F0%9F%85%B0&oq=%F0%9F%8D%81%E2%83%9D%F0%9F%85%B4%F0%9F%85%B5%F0%9F%85%B0 "链接")，页面会直接崩溃；如果你的 Chrome 版本低于 102，点击页面中的搜索栏，也会导致崩溃。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/unicode-error.gif)

问题如何排查出来的？

-   排查接口返回，但 postman 能正常工作
-   Chrome 开 Recorder 看看是不是代码性能有问题，导致内存溢出。发现崩溃发生在数据render，猜测数据有问题
-   mock 接口返回数据，发现可以正常显示，确定是数据的问题，最后定位到用户昵称中的这个特殊字符
    
![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/EsUq7C.jpg)

**如何修复这个问题**

1、向 Chromium 提交 [Bug 反馈](https://bugs.chromium.org/p/chromium/issues/detail?id=1313829 "Bug 反馈")，并且在 Chrome 102.0.5005.40 版本中修复。根据Google Devs 的回复，Bug 的原因是引入的一个[第三方字符引擎库](https://github.com/harfbuzz/harfbuzz/issues/3535 "第三方字符引擎库")导致的。这个库在解析 [COMBINING ENCLOSING CIRCLE](https://codepoints.net/U+20DD "COMBINING ENCLOSING CIRCLE") （组合封闭圈）字符时，会导致字符位置变更，使得 Blink 引擎无法处理。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/rtb6ot.jpg)

2、对特殊字符做兼容处理

遍历整个昵称，如果含有 emoji，则往后拼接一个零宽的空字符。（后面根据上面的 Bug 反馈，其实只需要对 ⃝ 这个字符单独做处理即可）

```JavaScript
const emojiRegex = /(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])/gi;
const parsedValue = runes(String(innerValue)).reduce(
    (acc, cur) => (emojiRegex.test(cur) ? `${acc}${cur}\u200d` : `${acc}${cur}`),
    ''
    );
```

**Unicode是什么？**

全世界有这么多国家，这么多的语种，字符数有成千上万种。如果能够把这些字符放到一个集合里，只要操作系统支持这个字符集，就不会产生乱码。为了解决这个问题，Unicode 标准出现了。

United Code? Unify Code? Blablabla....Whatever。。。来看看 Wikipidia 对其的定义：

> Unicode(alias **Universal Coded**)，is an information technology standard for the consistent encoding, representation, and handling of text expressed in most of the world's writing systems.
> 
> —— from [Wikipidia](https://en.wikipedia.org/wiki/Unicode "Wikipidia")

那么它是如何编码的呢？为了方便理解，首先想象有一个平面，我们人为地把一些常用字符放到这个平面中。然后使用16进制对字符的位置进行编码，这个字符在平面上的位置也叫做**码点**。例如‘字’这个字符在第 23383 个位置，编码为 `U+5B57`，‘节’这个字符在第 33410 个位置，编码为`U+8282`。!

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/NHIMWr.jpg)

![](https://bytedance.feishu.cn/space/api/box/stream/download/asynccode/?code=OTU5MGI3NjNiMWMxZTM3Zjc5OWI5NWYwZmYxZTg1ZTNfVENJYUNVRGJPNVh4MlREZDF6TWJocWpscm54T3RXaUxfVG9rZW46Ym94Y25OMUQwUnJTTVBKTlNVcUdHeHdEeFlkXzE2NTQxNjc1NDM6MTY1NDE3MTE0M19WNA)

```JavaScript
 //  ' '  字 节 跳 动 !
console.log('\u0020', '\u5B57', '\u8282', '\u8DF3', '\u52A8', '\u0021');
```

但是一个平面显然装不下所有的字符，最新的 Unicode 版本为2021年9月公布的14.0.0，已经收录超过 14 万个（其中 CJK 字符超过 9 万，占比 64%）。

因此，Unicode 还额外定义了其他 16 个平面，通过额外的两个十六进制数，来表示平面的位置。每个平面所表示的含义各不相同。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/qPI0th.jpg)

其中我们经常用到的 Emoji 就在1号平面下。

```JavaScript
// 为什么有两种表示方式呢？
console.log('\u{1F602}', '\uD83D\uDE02') // 😂 😂
```

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/PW3LD8.jpg)

需要注意的是，在 Unicode 标准中只规定了代码点对应的字符，并没有规定这些代码点怎么存储。对于不同的操作系统以及编程语言，都其各自的编码方式进行存储，有用 UTF-8 的、也有用 UTF-16 和 UTF-32 的。

以`😂`这个emoji为例，它的 Unicode 码位为 `U+1F602`，下面是不同的系统对其的编码形式：

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/IA3Drn.jpg)

那 JavaScript 是如何编码的呢？在 [ECMAScript 的标准](https://262.ecma-international.org/5.1/ "ECMAScript 的标准")中有提到：

> When a String contains actual textual data, each element is considered to be a single UTF-16 code unit.
> 
> 当一个字符串包含实际的文本数据时，每个元素被认为是一个单一的UTF-16编码单位。

UTF-16 的编码方式方式很巧妙，它是可变长度的。它用两个字节表示基本平面，如果是辅助平面的字符，则使用四个字节表示。

那么计算机在读取的过程中，遇到了两个字节，如何判断它本身是一个字符，还是需要将其他两个字节一起解读呢？

为解决这个问题，Unicode 将基本平面的两段代码点保留，不表示任意字符。`110110xx xxxxxxxx`（`0xd800` - `0xdbff`）为高位代理（High Surrogate），`110111xx xxxxxxxx`（`0xdc00` - `0xdfff`） 为低位代理(Low Surrogate)。当计算机读取到一个代理字符时，就知道这是一个辅助平面字符，需要将四个字节一起解读。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/IQaNah.jpg)

详细的编码方法为：

1.  如果代码点位于 `0x000000` - `0x00ffff`，直接进行二进制编码，位数不够的左边充 0。
2.  如果代码点位于 `0x010000` - `0x10ffff`，则： 
    1.  代码点减去 `0x010000`，会得到一个位于 `0x000000` 和 `0x0fffff` 之间的数字。
    2.  这个数字转换为 12 位二进制数，位数不够的，左边充 0，记作：`yyyy yyyy yyxx xxxx xxxx`。     
    3.  取出 `yy yyyyyyyy`，并加上 `11011000 00000000`(`0xD800`)，得到高位代理。
    4.  取出 `xx xxxxxxxx`，并加上 `11011100 00000000`(`0xDC00`)，得到低位代理。     
    5.  高位代理和低位代理相连，得到 `110110yy yyyyyyyy 110111xx xxxxxxxx`。
        

太长不看系列。。。如果是辅助平面的字符，Unicode 直接给了一个公式：

```JavaScript
const unicode2UTF16 = (codePoint) => {
    const H = Math.floor((codePoint-0x10000) / 0x400)+0xD800;
    const L = (codePoint - 0x10000) % 0x400 + 0xDC00;
    return [H.toString(16), L.toString(16)];
}

unicode2UTF16(0x1F602) // ['d83d', 'de02']
```

在 ES6 之前，Unicode 只能通过这种代理位字符的形式进行表示，ES6 增强了一些能力，例如上面提到的，可以直接将 Unicode 的码位包裹在 `{}` 中。

**前端如何正确处理 Unicode**

直接上案例。

1、字符长度

```JavaScript
'A'.length // 1
'𝐀'.length // 2
'😂'.length // 2
```

可以看到，如果是辅助平面的字符，JS 会将高低位的代理字符分开计数，视作两个字符。这样可能会让人感到困惑，那么如何才能得到正确的计数呢？

在 ES6 中，可以使用 `Array.from` 或者 `...` 拓展运算符。

```JavaScript
Array.from('𝐀').length // 1
[...'😂'].length // 1
[...'😂👀'].length // 2
[...'👨👩👧👦'].length // 7 （为什么是 7 呢？）
```

我们注意到，最后一个 👨👩👧👦 emoji 似乎比较特殊，他的长度为什么是 7 呢？我们尝试看一下解构后的数组。

```JavaScript
[...'👨👩👧👦'] // ['👨', ''(这不是普通的空字符哦), '👩', '', '👧', '', '👦']
''.charCodeAt(0).toString(16) // '200d'
```

通过数组解构， 👨👩👧👦 被拆分成了`👨👩👧👦`四个 emoji，并且使用一个特殊字符连接起来了。这个特殊的字符被称为 [Zero Width Joiner](https://emojipedia.org/zero-width-joiner/ "Zero Width Joiner") （零宽连接符），它可将两个或多个其他字符按顺序连接在一起以创建新的表情符号。这样我们的 emoji 世界就多样化起来了，同时也体现了更多包容性。

```JavaScript
// 超级英雄，当然不能只有男性
'🦸' + '\u200d' + '♂' // 🦸♂
'🦸' + '\u200d' + '♀' // 🦸♀

// 爱情，当然不仅仅只有异性
['👨', '', '❤', '️', '', '👨'].join('')   // 👨❤️👨
['👩', '', '❤', '️', '', '👩'].join('')   // 👩❤️👩

// 圣诞老人，也可以有各种肤色
Array.from({ length: 5 }, (_, i) => '🎅' + String.fromCodePoint(i + 0x1f3fb)) // ['🎅🏻', '🎅🏼', '🎅🏽', '🎅🏾', '🎅🏿']

// 各种发型
Array.from({ length: 4 }, (_, i) => '👩' + '\u200d' + String.fromCodePoint(i + 0x1f9b0)) // ["👩🦰", "👩🦱", "👩🦲", "👩🦳"]

// 给狗狗穿上衣服
'🐕' + '\u200d' + '🦺'  // 🐕🦺 
```

Emoji 的历史也很精彩有趣，值得单开一期。

OK，回到正题。对于这种组合的特殊字符（不仅仅是 emoji），应该如何正确的统计字符呢？手动剔除 `\u200d`？那如果有这种字符呢Z͑ͫ̓ͪ̂ͫ̽͏̴̙̤̞͉͚̯̞̠͍A̴̵̜̰͔ͫ͗͢L̠ͨͧͩ͘G̴̻͈͍͔̹̑͗̎̅͛́Ǫ̵̹̻̝̳͂̌̌͘!͖̬̰̙̗̿̋ͥͥ̂ͣ̐́́͜͞？

有一种方式是 ES2021 里的 [Intl.Segmenter](https://github.com/tc39/proposal-intl-segmenter "Intl.Segmenter") 方法，专门对 Unicode 进行分割。也可以使用第三方库 [grapheme-splitter](https://github.com/orling/grapheme-splitter "grapheme-splitter") 或者 lodash 的 [_.split](https://lodash.com/docs/4.17.15#split "_.split") 方法，兼容性更好。

```JavaScript
const segmenter = new Intl.Segmenter("en-US", {granularity: "grapheme"});
const segments = segmenter.segment('👨👩👧👦👩❤️👩');
// segment at code units [0, 11): «👨👩👧👦»
// segment at code units [11, 19): «👩❤️👩»
for (let {segment, index} of segments) {
  console.log("segment at code units [%d, %d): «%s»",
    index, index + segment.length,
    segment
  );
}
```

[Semi Input](https://semi.bytedance.net/zh-CN/input/input "Semi Input") 组件如何兼容这个问题？它把决定权交给了用户，长度计算函数作为参数让用户传入，因此在使用需要计算长度场景需要注意处理特殊的符号。

![](https://bytedance.feishu.cn/space/api/box/stream/download/asynccode/?code=MWQ4YTA2NmVlN2I0ODcwZDdmNWIwOGFmYWY1YTcwZTJfRHlvWmlaOUk0QUZjY3BXZ3VoalpkbTRMZ0p6UThsZklfVG9rZW46Ym94Y25aQ3JQTGw0dFZDRExibVVFczZxR1llXzE2NTQxNjc1NDM6MTY1NDE3MTE0M19WNA)

2、Normalize

[normalize](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize "normalize") 是 ES6 新增了一个 String 原型链上的方法，这个方法返回字符串的 Unicode 规范化形式。

```JavaScript
'mañana' === 'mañana'. // false
```

两个看起来一样的字符串，为什么不相等呢？有了上面的经验，我们尝试解构一下这个字符串。

```JavaScript
[...'mañana'] // ['m', 'a', 'ñ', 'a', 'n', 'a']
[...'mañana'] // ['m', 'a', 'n', '̃', 'a', 'n', 'a']
```

可以看到，第一个字符串包含码位 `U+00F1` 表示字母 n 和 n 头上波浪号，而第二个字符串使用两个单独的码位(`U+006E`表示字母 n 和 `U+0303` 表示波浪号)来创建相同的字符，因此两个字符串并不相等。

要解决这种问题也很简单，可以使用 normalize 方法，将字符串转换为 Unicode 的规范形式再进行比较。

```JavaScript
'mañana'.normalize() === 'mañana'.normalize()
```

3、字符反转

如果是普通的字符串反转，我们可以利用数组的 reverse 方法。

```JavaScript
const reverse = (str) => str.split('').reverse().join('');

reverse('123') // '321'
reverse('mañana') // 'anãnam'  ❌
reverse('ha😂ha')  // 'ah\uDE02\uD83Dah' ❌
```

但是上面的 reverse 方法无法处理组合字符和辅助平面的字符，可以使用上面提到的 Lodash 的[_.split](https://lodash.com/docs/4.17.15#split "_.split") 方法稍加改造。

```JavaScript
const reverse = (str) => _.split(str, '').reverse().join('');

reverse('123') // '321'
reverse('mañana') // 'anañam' ✅
reverse('ha😂ha')  // 'ah😂ah' ✅
```

**总结**

-   Unicode，就是一个字符标准，它使用码点进行标记位置，将全世界各种各样的字符放进了一个集合。
    

-   Unicode 处理场景，需要谨慎，能用第三方库处理的尽量别手写。
    

**延伸阅读**

-   [Unicode in JavaScript](https://flaviocopes.com/javascript-unicode/ "Unicode in JavaScript")
-   [Stackoverflow:How to count the correct length of a string with emojis in javascript?](https://stackoverflow.com/questions/54369513/how-to-count-the-correct-length-of-a-string-with-emojis-in-javascript "Stackoverflow:How to count the correct length of a string with emojis in javascript?")
-   [codepoints.net](https://codepoints.net/ "codepoints.net") 查看每个字符对应的码点信息