---
title: PWA 离线缓存技术在大型 B 端站点的应用与实践
date: 2022-09-03 9:30:00
tags: 
  - 离线缓存
  - Service Worker
  - PWA
categories: 前端
---

我们团队负责的某运营平台的建设，随着项目的不断迭代，各种需求与功能的增加，目前各个子模块超过了数百个，站点加载慢的问题也逐渐显现，相关指标趋于恶化。通过调研发现，主要原因有以下两点：

1.  页面初始化依赖的接口较多，其中不乏包括权限、地区、项目配置等相关接口，而且由于历史原因，这些接口的响应速度较慢，改造成本较高。

2.  基于微前端+SPA应用架构的加载链路较长，主应用加载完成后还需要请求网络，加载子应用的页面及其资源，导致子应用有较长的白屏时间。下图展示了目前站点原有的加载链路。

![站点加载流程](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/image-20220828114655255.png)


为了加快页面的加载速度，减少资源和接口的慢请求率，采用 PWA 离线缓存的技术，将相关的页面、资源和请求进行离线缓存，并在加载的交互上进行改进，整体提升了站点的使用体验，并帮助运营同学提升工作效率。

#### 技术方案选型

首先思考下面三个问题：

1.  为什么选择使用 PWA？
2.  为什么有了 HTTP 缓存还需要做离线缓存？
3.  B 端产品是否适合接入？

其实 PWA（Progressive web application）技术并不是什么新奇的概念，近些年的应用比较广泛，因此技术相对比较成熟。通过操作浏览器提供的 Service Worker API，可以离线缓存接口数据、静态资源，大幅降低请求处理速度，缩短首屏加载时长，达到和原生应用接近的体验。像是推送通知、通知功能和添加至主屏功能也得到了广泛的支持。**更重要的是，我们只需要相对较小的代价就可以实现 PWA 的核心特性，而带来的收益却是非常可观的。**

对于使用了 PWA 技术的应用来说，如下图所示，浏览器端在请求资源时会遵循 ServiceWorker Cache > Disk Cache 的优先级顺序，而这两种缓存的加载速度分别为 Disk Cache > ServiceWorker Cache。另外，一些现代浏览器还会有 Memory Cache，这种缓存的优先级以及加载速度均优于 Service Cache 和 Disk Cache。

![缓存顺序](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/1280X1280%20(2).png)


图片来源：[Web.Dev](https://web.dev/i18n/zh/service-worker-caching-and-http-caching/)

那么在之前站点的大部分资源已经做了 HTTP 缓存，为什么还要做离线缓存呢？（PS：小孩子才做选择，大人全都要。）其实二者并不冲突，经过调研发现，两者的缓存获取的时间相差为毫秒级，几乎可以忽略不计，而在并发请求数量较多的情况下， [Service Worker Cache 速度比 Disk Cache 更快](https://segmentfault.com/a/1190000041736677)。我们也可以通过资源竞速的方式，拿到最快的资源。最重要的是，离线缓存给我们带来的最显著的收益是优化了微前端 + SPA 的加载链路过长的问题，通过更细粒度以及可控的缓存，来初始化页面的请求以及主子应用的 App-shell 和资源，加快页面的加载速度，减少白屏时间。

另外，作为一个 B 端产品，我们的用户群体是单一和固定的，但是页面的访问频次相对较高，Service Worker 接口请求的缓存策略非常适合我们的接口优化。同时PWA 的改造成本相对较小，给我们带来收益确实很可观，除了缓存优化外，在之后我们还可以使用 PWA 提供的通知推送、添加主屏的功能，进一步提升用户体验，这也是我们选择 PWA 的主要原因之一。

### 插件对比

我们站点的构建工具为字节内部的工具，提供了配套的 pwa 插件，这里与 Google 提供的 webpack 插件做一个对比。

|      | 内部插件                                                     | [workbox-webpack-plugin](https://www.npmjs.com/package/workbox-webpack-plugin) |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 介绍 | 对[workbox-webpack-plugin](https://www.npmjs.com/package/workbox-webpack-plugin)插件的封装 | 工具库，提供了一系列对 Service Work 操作的 API               |
| 部署 | 整合了部署的能力，不用单独配置部署的路由                     | 需要增加一个 sw.js 的路由                                    |
| 配置 | 配置简单，但是配置项太少，只能覆盖到一小部分场景，适合小型的应用 | 配置有点复杂，手写的东西较多，但是能够覆盖到大部分场景。     |
| 打包 | 自动生成 service-worker.js 文件，html 自动注入 Service Worker 注册的script | 自动生成 service-worker.js 文件，Service Worker 注册需要手写，因此可以自定义降级方案 |

根据上述对比，发现 workbox-webpack-plugin 的自定义配置项更丰富，能够覆盖此次改造需求的场景，可以自定义降级方案，因此选用 workbox-webpack-plugin 插件进行 PWA 的配置。

### Service Worker 离线缓存

页面初次加载 Service Worker 处于未被激活的状态，无法拦截页面的请求进行缓存。只有处于 activated 状态后才会接管页面的请求。也就是说，第一次打开页面依然会请求所有的资源，在安装 Service Worker 之后，需要刷新页面才能有缓存的效果。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/screenshot-20220830-104307.png)



#### 缓存策略

| **Cache First**                                              | **Network First**                                            | **StaleWhileRevalidate**                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 优先使用缓存，缓存不存在请求网络                             | 优先使用网络请求，网络异常情况使用缓存                       | 优先使用缓存，缓存不存在使用网络；缓存存在则先使用缓存，同时在后台请求网络资源更新缓存 |
| ![img](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/(null).jpg) 图片来源：[Google Developers](https://developer.chrome.com/docs/workbox/modules/workbox-strategies/) | ![img](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/(null)-20220828114924137.(null)) | ![img](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/(null)-20220828114930732.(null)) |

#### Precache vs Runtime Cache

Service Worker 里的缓存分为 Precache 和 Runtime Cache。

Precache 即预缓存，它在 build 阶段产生一个名为 workbox-precaching 预缓存清单，使build产物保持最新，并使用缓存优先策略设置路由以提供预缓存的 URL。只要一打开页面，它就会在后台把清单里资源去请求一遍并进行缓存，而不需要等到浏览器接管相应的请求后再缓存。

Runtime Cache 是运行时预缓存，即在页面的使用过程中，只要命中了所设置的路由规则，就往 Service Worker 中记录一条。

通常来说，第一次打开页面，会在后台缓存 Precache 的资源，第二次刷新后即可使用。如果是 Runtime 的缓存，一般需要等到第三次刷新才能够使用。

#### Service Worker 更新策略

默认情况，当监测到有新的 Service Worker，会经历两个阶段：

1.  再次触发 intall 事件，但如果页面没关闭，页面依旧被老的 Service Worker 托管，新的 Service Worker 处于 waiting 状态。
    
2.  当用户完全关闭页面后（浏览器所有的tab都没有打开该站点），并再次打开页面才会触发 activate 事件。此时新的 Service Worker 接管页面，新的缓存也会开始生效。
    

考虑到用户会有打开多个 Tab 的习惯，这种方案无法通过简单的刷新页面来看到最新的效果，需要关闭所有相关的 Tab 才可以，对用户使用心智不太友好。

还有一种方式是通过 `skipWaiting` 方法直接刷新，但这样可能出现缓存冲突的情况。 因为注册Service Worker是个异步过程，可能出现同一个页面前后经过两个 Service Worker，就有[存在问题的风险](https://stackoverflow.com/questions/51715127/what-are-the-downsides-to-using-skipwaiting-and-clientsclaim-with-workbox?noredirect=1&lq=1)。例如有新功能上线后，用户刷新页面，部分资源走的老的缓存，新的 Service Worker 注册好后，如果老的缓存里有异步请求，则缓存和线上都无法命中，导致资源请求失败。

| **默认方式**                                      | **skipWaiting**                                            |
| ------------------------------------------------- | ---------------------------------------------------------- |
| 需要关闭所有 tab，新的缓存才会生效                | 刷新当前页面，缓存立即生效                                 |
| 优点： 最安全，没有风险缺点：用户使用心智不太友好 | 优点：用户无感知缺点：潜在问题，可能会导致异步资源请求失败 |

通过对比方案，可以看到两种方式均有不妥，技术不是万能，有缺点需要产品逻辑进行结合弥补。我们使用 postMessage + skipWaiting 的更新方式，页面监听 `message` 事件，并在回调中刷新页面。具体的表现形式为当页面检测到有新的 Service Worker 注册时，页面弹出提示框，提示用户刷新页面。当用户点击 Load New 按钮时，通过 postMessage API 发送一条通知，所有页面即会刷新并获取到最新缓存。

![Service Worker 更新提示](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/(null)-20220828115029882.(null))

### 资源缓存

#### Build 打包资源

编译产物采用 CacheFirst 方案做预存储（preCache），每次更新时根据文件 hash 或者文件 revision 标识进行缓存状态更新。

[workbox-webpack-plugin](https://www.npmjs.com/package/workbox-webpack-plugin) 会识别一个 `__WB_MANIFEST` 特殊变量，在构建结果中该变量会替换成manifest array。每次打包构建，生成的文件会更新，进而触发 Service Worker 更新。

```JavaScript
// self.__WB_MANIFEST 代指 build 的文件列表
[
  {
    'revision': '23fadff0671aa',
     'url': '/common/137.ff0671aa3b.js'
  }, 
  {
    'revision': '6324c478f69e3',
    'url': '/common/632.4c478f69e3.js'
  }
]
```

```JavaScript
// generate sw.js config
precacheAndRoute(
    // __WB_MANIFEST 是 workbox-webpack-plugin 内置的一个变量，build 后会自动替换为替换为预缓存清单
    self.__WB_MANIFEST.filter(
      i =>i.url.endsWith('js') || i.url.endsWith('css'),
    ),
  );
```

#### 三方静态资源

-   字体、图片、图标
    
-   SDK，站点中包括监控、打点、Oncall 客服 SDK 等等
    

对于字体文件，图片，以及带版本号的第三方sdk，采用 Cache First 策略，设置 30 天的缓存时间。对于其他的静态资源（不包含 build 产物），例如外部的样式、不带版本号的 sdk，采用 StaleWhileRevalidate 策略。在命中缓存的同时，后台请求最新的资源并进行更新，保证资源的实时性。

```JavaScript
const staleWhileRevalidate = (cacheName, maxEntries) => new StaleWhileRevalidate()

const cacheFirst = (cacheName, maxEntries, maxAgeSeconds = 60 * 60 * 24 * 30) => new CacheFirst()

const sdk = {
  versioned: ['somesdks'],
  unversioned: ['somesdks'],
}

const registerSDKCache = () => {
  registerRoute(
    ({ request }) => sdk.versioned.some(r => request.url.includes(r)),
    cacheFirst('asset-sdk_versioned', 100)
  );
  registerRoute(
    ({ request }) => sdk.unversioned.some(r => request.url.includes(r)),
    staleWhileRevalidate('asset-sdk_unversioned', 100)
  );
};
  
const registerStaticAssetsCache = () => {
  registerRoute(({ request }) => ['image', 'font'].includes(request.destination), cacheFirst('asset-static', 100));
};
```

#### 请求

页面初始化依赖的接口较多，可以缓存这些请求，来加快初始化的速度。例如 `xxx/xxxx/appInfo`，这个接口返回一些项目的配置信息，例如 权限、Oncall 等等。根据监控发现，这个请求超过 1s 的比例达到 15%，而且会阻塞页面渲染。目前来看，这类请求的 response 数据长时间不会有更新，选择使用 StaleWhileRevalidate 的方式缓存起来。

```JavaScript
const requests = [
    '/xxxx/xxxx/appInfo',
    // others...
];

const registerRequestCache = () => {
  registerRoute(({ request }) => requests.some(r => request.url.includes(r)), staleWhileRevalidate('requests', 30));
};
```

#### App-shell

站点使用微前端的架构，加载各个子应用有一定耗时，因此选择缓存主子应用的 App-shell，来减少主子应用的网络请求时长，加快整个加载链路。

| 页面链接             | 描述               |
| -------------------- | ------------------ |
| https://xxxx/index   | 主应用 index.html  |
| https://xxxx/subappA | 子应用A index.html |
| https://xxxx/subappB | 子应用B index.html |
| https://xxxx/subappC | 子应用C index.html |

```JavaScript
const registerNavigatorCache = () => {
  registerRoute(
    new NavigationRoute(staleWhileRevalidate('navigator', 100), {
      // match /path or /path/123
      allowlist: ['/', '/index', ...navigatePaths].map(path => new RegExp(`${path}/?[0-9]*$`)),
    })
  );
};
const registerSubAppCache = () => {
  const subAppShellRegex = new RegExp('xxxxx'); // app-shell router
  registerRoute(
    ({ request }) => subAppShellRegex.test(request.url), staleWhileRevalidate('subapp-shell', 10)
  );
};
```

最终 Service Worker 的缓存结构如下：

```JavaScript
- asset-static // image、font
- asset-sdk_versioned // 带版本号的资源
- asset-sdk_unversioned // 不带版本的静态资源
- workbox-precache // 预缓存数据 （build 产物）
- request // 配置项的请求
- navigator // SPA 路由
- app-shell // 应用的 index.html
```

另外，我们还使用了开屏的衔接 Logo，等待主应用加载完成，进一步提升使用体感。为了防止主应用加载快导致的频闪，设置了一个最小的 Logo 延时显示，并与主应用的加载并发进行。

```JavaScript

const Layout = lazy(() =>
  // for fallback lading, delay 500ms at least to show the main layout
  Promise.all([import('../layout/index'), new Promise(resolve => setTimeout(resolve, 500))]).then(
    ([moduleExports]) => moduleExports
  )
);
```

### Service Worker 注册

`sw.js` 注册在页面的 load 事件中，打点记录一下注册情况。

```JavaScript
<script>
  if('serviceWorker' in navigator){
    window.addEventListener('load', function() {
      navigator.serviceWorker
        .register('/sw.js')
        .then(function (reg) {
          // 打点记录注册状态
        	// ... 
        })
        .catch(function (e) {
        });
    })
  }
</script>
```

### 更新检测

我们封装了一个原生的更新检测弹框组件，组件会监听 Service Worker 生命周期的事件（包括 updatefound、controllerchange、statechange）以及 `message` 事件，并根据用户的交互进行刷新缓存的操作。

![更新检测流程](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/screenshot-20220830-104418.png)

Service Worker 更新检测监听

```JavaScript
// sw.js
self.addEventListener("message", event => {
    if (event.data === "skipWaiting") {
       self.skipWaiting();
     }
});
// update-found.js
button.addEventListener('click', function() {
  registration.waiting.postMessage("skipWaiting");
})
navigator.serviceWorker.addEventListener("controllerchange", function(event) {
    window.location.reload();
});
// ...
registration.addEventListener("updatefound", function() {
  registration.installing.addEventListener("statechange", function(event) {
     if (event.target.state === "installed") {
        // 弹出更新提示框
         callback();
     }
  });
});
// ...
```

### 降级方案及灰度发布

为了避免缓存出现一些问题，导致页面无法加载或者白屏之类的问题，需要提供一个 Service Worker 注销的方案。在动态配置中心上增加一个 key 作为开关，在页面加载时请求配置，根据配置选择注册更新 Service Worker 还是注销所有的 Service Worker。另外配置中还包含灰度的地区，只有选择对应的灰度地区才会注册 Service Worker。

```JavaScript
// tcc api
FETCH_CONFIG: `/xxxx/getconfig/`;
window.addEventListener("load", () => {
  fetch(FETCH_CONFIG)
    .then(function (res) {
      return res.json();
    })
    .then(function (res) {
        var configData = res && res.data && JSON.parse(res.data);
        if (configData && (configData.pwaDisabled || !configData.pwaEnableRegion.includes(regionName))) {
            // 注销 service worker
            enableServiceWorker = false;
        }
    })
    .finally(function () {
        if (enableServiceWorker) {
            // 注册 service worker
        }
    })
});

// 打点记录
```

## 收益以及反馈

通过此次 PWA 的改造，站点整体的 FCP、Load 以及慢请求率指标有了明显的改善，达到了预期值。

|         | FCP       | Load  | Main Resource Slow Request Rate |
| ------- | --------- | ----- | ------------------------------- |
| Before  | 2115.38ms | 2.42s | 11.29%                          |
| After   | 1388.06ms | 1.16  | 5.37%                           |
| Percent | 🔺52%      | 🔺240% | 🔻52.4%                          |

但 LCP、TTI 等指标仍较高，后续会进一步从代码逻辑层面和打包层面做进一步优化，提升交互体验。

-   从代码逻辑层面，对页面渲染、图片加载、减少 long task 等方面进行优化
    
-   打包层面，合理拆包，去除不必要的包等等方面
    
另外，功能上线后，我们也收到了来自 PM、RD 以及相关用户的一些正向反馈，这对我们来说是莫大的鼓舞。我们也会持续关注性能方面的优化，持续精进。

最后插入一则广告，TikTok Creator Growth 团队仍在招聘前后端工程师，校招和社招均可，有意向的同学可以加微信细聊 🙏。

![](https://mayandev.oss-cn-hangzhou.aliyuncs.com/upicBlog/IMG_4504.JPG)