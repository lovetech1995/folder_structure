#!/bin/bash

# 1. Kiểm tra xem người dùng có nhập tham số hay không
if [ -z "$1" ]; then
  echo "------------------------------------------------"
  echo "LỖI: Bạn chưa nhập tên dự án!"
  echo "Cách dùng đúng: bash $0 <ten-du-an>"
  echo "Ví dụ: bash $0 my-new-app"
  echo "------------------------------------------------"
  exit 1 # Dừng script ngay tại đây nếu không có input
fi

# 2. Gán tham số vào biến
PROJECT_NAME=$1


echo "--------------------------------------------------"
echo "Bắt đầu tạo dự án React: $PROJECT_NAME"
echo "--------------------------------------------------"

# 1. Tạo React App
echo "Đang chạy create-react-app..."
npx create-react-app $PROJECT_NAME

if [ ! -d "$PROJECT_NAME" ]; then
    echo "Lỗi: Không thể tạo dự án React."
    exit 1
fi

cd $PROJECT_NAME

# 2. Cài đặt thư viện
# - Cập nhật: Bỏ lottie-react
# - Thêm: firebase, numeral, lodash, react-countdown
echo "Đang cài đặt thư viện..."
npm install @reduxjs/toolkit react-redux antd axios moment react-router-dom react-icons firebase numeral lodash react-countdown react-helmet

# Tailwind
npm install -D tailwindcss@3 postcss autoprefixer 
npm i prettier-plugin-tailwindcss --legacy-peer-deps
npx tailwindcss init -p



# cài firebase
npm install firebase

echo "Đã cài đặt xong thư viện."

# 3. Tạo cấu trúc thư mục
echo "Đang tạo cấu trúc thư mục..."

mkdir -p src/asset/img
mkdir -p src/asset/svg
mkdir -p src/asset/lottie

mkdir -p src/component/loader
mkdir -p src/component/form
mkdir -p src/component/page
mkdir -p src/component/cards
mkdir -p src/component/upload

mkdir -p src/config
mkdir -p src/css

mkdir -p src/hook/default
# Các file hook riêng biệt sẽ được tạo ở bước sau

mkdir -p src/screen/00_Nav

# Tạo các thư mục con
echo "Đang tạo cấu trúc thư mục con..."
mkdir -p src/screen/00_Nav/component/trigger
mkdir -p src/screen/00_Nav/layout
mkdir -p src/screen/00_Nav/route
mkdir -p src/screen/00_Nav/trigger
 


mkdir -p src/screen/01_Home
mkdir -p src/screen/99_Term
mkdir -p src/screen/98_Data_Privacy
mkdir -p src/screen/100_Dev

mkdir -p src/store/default

mkdir -p src/utils

echo "Đã tạo xong thư mục."

# 4. Setup Config & Tailwind
echo "Đang cấu hình Tailwind và Config..."

# Tailwind config
cat > tailwind.config.js <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF


#appjs
cat > src/App.js <<EOF
import React from "react";
import { App, ConfigProvider } from "antd";
import AppRoot from "screen/00_Nav/app_root";


const MyApp = () => {
  return (
    <ConfigProvider theme={{}}>
      <App>
        <AppRoot />
      </App>
    </ConfigProvider>
  );
};

export default MyApp;
EOF


# src/css/common.css
cat > src/css/common.css <<EOF
/* Global Common Styles */
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

* {
  box-sizing: border-box;
}

/* Utility classes có thể thêm ở đây */
.text-center { text-align: center; }
.w-full { width: 100%; }
EOF

# src/config/config.js (Firebase Config)
cat > src/config/config.js <<EOF
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
 

export const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// recapcha
export const BRAND_NAME = ""; // Brand Name
export const PROJECT_ID = "$PROJECT_NAME";
export const SOURCE = "client";
export const app = initializeApp(firebaseConfig, PROJECT_ID);
export const reCAPTCHA = "";
export const MEDIA_STORAGE =
  "https://storage.googleapis.com/" + firebaseConfig.storageBucket + "/";

EOF

# 5. Setup Store Structure
echo "Đang setup Redux Store..."

# src/store/ref.js
cat > src/store/ref.js <<EOF
export const REGION = "asia-southeast1";
// local
export const LOCAL_USER = "Local User";
EOF

# src/store/string.js
cat > src/store/string.js <<EOF
export const STRINGS = {
  LOADING: "Đang tải...",
  ERROR: "Có lỗi xảy ra",
  SUCCESS: "Thành công",
};
export default STRINGS;
EOF

# src/store/default/ref.js (Setup Firestore sẵn)
cat > src/store/default/ref.js <<EOF
import { getApp } from "firebase/app";
import { getFirestore, collection } from "firebase/firestore";

// =============================== BASE  ===============================  //
const app = getApp();

export const REF = {
  NAME: "(default)",
  COLLECTIONS: {
    PAPER: "paper",
    SETTING: "setting",
    HACKER: "hacker",
  },
};

export const getRefs = () => {
  const firestore = getFirestore(app, REF.NAME);
  const CREF = {
    paper: collection(firestore, REF.COLLECTIONS.PAPER),
    setting: collection(firestore, REF.COLLECTIONS.SETTING),
    hacker: collection(firestore, REF.COLLECTIONS.HACKER),
  };
  return CREF;
};

EOF

# src/store/default/default.action.js
cat > src/store/default/default.action.js <<EOF
import { TYPES } from "./default.type";
import {
  onSnapshot,
  query,
  where,
} from "firebase/firestore";
//func
import { getRefs } from "../ref";
import { getApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const app = getApp();
const auth = getAuth(app);

// ========= firebase function =========//

//snap all provider
const allDefaultSub = [];
export const snapDefault = (callback) => (dispatch) => {
  setDefaultAllSuccess(dispatch, null);
  const cRef = getRefs().hacker;
  const uid = auth?.currentUser?.uid;
  const c1 = where("owner", "==", uid);
  const c2 = where("source", "==", "client");
  const qRef = query(cRef, c1, c2);
  const unsub = onSnapshot(qRef, (snapshot) => {
    if (snapshot) {
      const data = snapshot.docs.map((doc) => doc.data());
      setDefaultAllSuccess(dispatch, data);
      if (callback) {
        callback();
      }
    }
  });
  allDefaultSub.push(unsub);
};

export const unSnapDefault = () => (dispatch) => {
  allDefaultSub.forEach((subscriber) => {
    subscriber();
  });
  allDefaultSub.length = 0;
};
// ========= cloud function =========//
// ========= local function =========//
export const setDefaultAll = (data, callback) => (dispatch) => {
  setDefaultAllSuccess(dispatch, data);
  if (callback) {
    callback();
  }
};

// ========= dispatch =========//

const setDefaultAllSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.SET_DEFAULT_ALL,
    payload: data,
  });
};

EOF

# src/store/default/default.reducer.js (Alias to slice hoặc logic riêng)
cat > src/store/default/default.reducer.js <<EOF
import { TYPES } from "./default.type";

const initState = {
  defaultAll: null,
};

const defaultReducer = (state = initState, action) => {
  const { type, payload } = action;
  switch (type) {
    case TYPES.SET_DEFAULT_ALL:
      return {
        ...state,
        defaultAll: payload,
      };

    default:
      return state;
  }
};

export default defaultReducer;

EOF

# src/store/default/default.selector.js
cat > src/store/default/default.selector.js <<EOF
export const defaultAllSelector = (state) =>
  state?.defaultReducer?.defaultAll;

EOF

# src/store/default/default.type.js
cat > src/store/default/default.type.js <<EOF
export const TYPES = {
  SET_DEFAULT_ALL: "default/SET_DEFAULT_ALL",
};

EOF

# src/store/root.reducer.js
cat > src/store/root.reducer.js <<EOF
import { combineReducers } from "@reduxjs/toolkit";
import authReducer from "./auth/auth.reducer";
import loginReducer from "./login/login.reducer";
import navReducer from "./nav/nav.reducer";

const rootReducer = combineReducers({
authReducer,
loginReducer,
navReducer,
});

export default rootReducer;


EOF

 

# 6. Tạo các file Hook
echo "Đang tạo các file Hook..."

cat > src/hook/useAuth.js <<EOF
import { App } from "antd";
import { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { useNavigate } from "react-router-dom";
import {
  checkEmail,
  registerEmailPassword,
  sendEmail,
  setStepRegister,
  verifyEmail,
} from "store/auth/auth.action";
import { registerSelector } from "store/auth/auth.selector";
import { firebaseLoginWithGoogle } from "store/login/login.action";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
export const useSignUp = () => {
  // -------------------------- VAR -----------------------------
  const navigate = useNavigate();
  const { message } = App?.useApp();
  // -------------------------- STATE ---------------------------
  const [loading, setLoading] = useState(false);
  const [checking, setChecking] = useState(false);
  // -------------------------- REDUX ---------------------------
  const dispatch = useDispatch();
  const register = useSelector(registerSelector);
  // -------------------------- FUNCTION ------------------------

  // bước nhập thông tin.
  const handleSentMail = ({ values }) => {
    setLoading(true);
    if (!values) return message.error("Làm ơn điền email, password!");
    const register = values;
    dispatch(
      checkEmail({ register }, (res) => {
        if (res?.status === 200) {
          const email = register?.email;
          sendEmailAndNext(email);
        }
        if (res?.status === 500) {
          message.error(res?.data);
        }
      }),
    );
  };

  const sendEmailAndNext = (email) => {
    dispatch(
      sendEmail({ email }, (response) => {
        setLoading(false);
        if (response?.status === 200) {
          dispatch(setStepRegister(1));
        }
        if (response?.status === 500) {
          const error = response.data;
          message.error(error);
        }
      }),
    );
  };

  // dành cho bước verify code.
  const onChangeCode = (pincode) => {
    const max = 6;
    if (pincode?.length === max) {
      onFinish(pincode);
    }
  };

  const onFinish = (pincode) => {
    if (!register) return message.error("Thông tin đăng ký không tìm thấy !");
    setChecking(true);
    const email = register?.email;
    dispatch(
      // register
      verifyEmail({ email, pincode }, (response) => {
        if (response?.status === 200) {
          dispatch(
            registerEmailPassword({ register }, (res) => {
              if (res?.status === 200) {
                setChecking(false);
                dispatch(setStepRegister(0));
                message.success(
                  "Đăng ký thành công, xin vui lòng đăng nhập vào nền tảng",
                );
              } else {
                setChecking(false);
                const code = res.data;
                message.error(code);
              }
            }),
          );
        }
        if (response?.status === 500) {
          setChecking(false);
          const error = response.data;
          message.error(error);
        }
      }),
    );
  };

  // gửi lại mã code khác.
  // eslint-disable-next-line no-undef
  const onGetCode = ({ disabled, setLoading = () => {} }) => {
    if (!register) return message.error("Làm ơn điền thông tin đăng ký");
    if (disabled) return;

    const email = register?.email;
    setLoading(true);
    dispatch(
      sendEmail({ email }, (response) => {
        setLoading(false);
        if (response?.status === 200) {
          const text = "Gửi mã thành công";
          message.success(text);
        }
        if (response?.status === 500) {
          const error = response.data;
          message.error(error);
        }
      }),
    );
  };

  // đăng nhập với login.
  const handleLoginWithGoogle = () => {
    setLoading(true);
    dispatch(
      firebaseLoginWithGoogle((res) => {
        if (res?.status === 200) {
          message.success("Đăng nhập thành công");
        }
        if (res?.status === 500) {
          setLoading(false);
          message.error(res?.data);
        }
      }),
    );
  };

  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return {
    loading,
    handleSentMail,
    checking,
    onChangeCode,
    handleLoginWithGoogle,
    onGetCode,
  };
};

EOF

cat > src/hook/usePrev.js <<EOF
import { useEffect, useRef } from "react";

//
//component
//redux
//selector
//actions
//utils
//hook
//str
export const usePrev = (value) => {
  // -------------------------- VAR -----------------------------
  const ref = useRef();
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  useEffect(() => {
    ref.current = value; // Cập nhật ref sau khi render
  }, [value]);
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return ref.current;
};

EOF

cat > src/hook/useLogged.js <<EOF
import { useSelector } from "react-redux";
import { isLoggedSelector } from "store/auth/auth.selector";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
export const useLogged = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  const logged = useSelector(isLoggedSelector);
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return { logged };
};
EOF

cat > src/hook/useMenu.js <<EOF
import { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import lodash from "lodash";
import {
  newItems,
  newMenus,
  newAuthMenu,
  newDashboard,
} from "../screen/00_Nav/url";
import { useClaimToken } from "./useToken";
import { useLogged } from "./useLogged";

export const useMenu = () => {
  // -------------------------- VAR --------------------------
  const { permissions } = useClaimToken();
  const { logged } = useLogged();
  // -------------------------- STATE --------------------------
  const [items, setItems] = useState({});
  const [menu, setMenu] = useState([]);
  const [authMenu, setAuthMenu] = useState([]);
  const [dashboard, setDashboard] = useState(null);
  // -------------------------- REDUX --------------------------
  // -------------------------- FUNCTION --------------------------
  // -------------------------- EFFECT --------------------------
  useEffect(() => {
    const items = newItems();
    const byPermissions = filterPermission(items, permissions);
    const menu = newMenus(byPermissions);
    const authMenu = newAuthMenu(byPermissions, logged);
    const dashboard = newDashboard(byPermissions);
    setItems(byPermissions);
    setMenu(menu);
    setAuthMenu(authMenu);
    setDashboard(dashboard);
  }, [logged, permissions]);
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN --------------------------
  return { items, menu, authMenu, dashboard };
};

const filterPermission = (items, permissions) => {
  const list = Object.entries(items)
    .map((item) => {
      const key = item[0];
      const value = item[1];
      const require = value?.require;
      const diff =
        require?.length > 0 ? lodash.difference(require, permissions) : [];
      const valid = diff?.length === 0 ? true : false;
      return { key, value, valid };
    })
    .filter((item) => item?.valid)
    .reduce((obj, item) => Object.assign(obj, { [item.key]: item.value }), {});
  return list;
};

EOF

cat > src/hook/useResponsive.js <<EOF
import { useEffect, useState } from "react";
import { Grid } from "antd";
//components
//actions
//selector
//function
//str
const { useBreakpoint } = Grid;

export const useResponsive = () => {
  // -------------------------- VAR ----------------------------
  const screen = useBreakpoint();
  // -------------------------- STATE --------------------------
  const [mobile, setMobile] = useState(false);
  const [tablet, setTablet] = useState(false);
  const [desktop, setDesktop] = useState(false);
  // -------------------------- REDUX -------------------------
  // -------------------------- FUNCTION ---------------------
  // -------------------------- EFFECT ------------------------
  // -------------------------- RENDER ------------------------
  useEffect(() => {
    if (screen?.xs) {
      setMobile(true);
      setTablet(false);
      setDesktop(false);
    }

    if (screen?.sm) {
      setMobile(false);
      setTablet(true);
      setDesktop(false);
    }

    if (screen?.md) {
      setMobile(false);
      setTablet(true);
      setDesktop(false);
    }

    if (screen?.lg) {
      setMobile(false);
      setTablet(false);
      setDesktop(true);
    }

    if (screen?.xl) {
      setMobile(false);
      setTablet(false);
      setDesktop(true);
    }

    if (screen?.xxl) {
      setMobile(false);
      setTablet(false);
      setDesktop(true);
    }
  }, [screen]);
  // -------------------------- MAIN ---------------------------
  return { mobile, tablet, desktop };
};

EOF

 
# 7. Cập nhật index.js và index.css
echo "Đang cập nhật entry point..."

 

cat > src/index.js <<EOF
import React from "react";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import {
  initializeAppCheck,
  ReCaptchaEnterpriseProvider,
} from "firebase/app-check";
import { app, reCAPTCHA } from "config/config";
import { getAnalytics } from "firebase/analytics";
import { configureStore } from "@reduxjs/toolkit";
import rootReducers from "./store/root.reducer";
import reportWebVitals from "./reportWebVitals";
import App from "./App";
import "./css/common.css";
import "./index.css";

if (window.location.hostname === "localhost") {
  window.self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;
}

initializeAppCheck(app, {
  provider: new ReCaptchaEnterpriseProvider(reCAPTCHA),
  isTokenAutoRefreshEnabled: true,
});

 
getAnalytics(app);

const store = configureStore({
  reducer: rootReducers,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

if (process.env.NODE_ENV !== "development") {
  console.log = () => {};
}

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <Provider store={store}>
    <App />
  </Provider>,
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();

EOF

cat > src/index.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Các style base khác nếu cần */
EOF

# 8. Tạo file layout cơ bản cho 00_Nav
cat > src/screen/00_Nav/url.js <<EOF
import { AiOutlineHome } from "react-icons/ai";
import { FcFolder } from "react-icons/fc";
import { BsChevronDown } from "react-icons/bs";
import { RiBillLine } from "react-icons/ri";

export const URL = {
  home: "/",

  // login.
  login: "/login",
  signin: "/signin",

  // bailiff detail.
  dialog: "/bailiff/:bailiffId",
  list: "/bailiff",
  billing: "/billing",

  //
  system: "system",
  term: "/term-of-service",
  privacy: "/privacy-policy",
  dev: "/dev",
};

// -------------------------- ITEM MAPPING --------------------------
export const newItems = () => {
  const items = {
    home: {
      title: "Dashboard",
      url: URL.home,
      key: "1",
      hightlight: ["1"],
      require: [],
      arrow: false,
      icon: <AiOutlineHome />,
    },
    dashboard: {
      title: "Khu vực lưu trữ",
      url: URL.home + "bailiff",
      key: "1",
      hightlight: ["1"],
      require: [],
      arrow: false,
      icon: <FcFolder />,
    },
 

    login: {
      title: "Đăng nhập",
      url: URL.home,
      key: "1",
      hightlight: ["1"],
      require: [],
      arrow: false,
    },
  };
  return items;
};

// -------------------------- BREAD CRUMB --------------------------
// -------------------------- MENU --------------------------
export const setMenuItem = (props) => {
  if (props?.title) {
    const { title, url, key, arrow, icon, children } = props;
    const href = url;
    let label = href ? (
      <>
        <a href={href} target="_self" rel="noopener noreferrer">
          {title}
        </a>
        {arrow ? (
          <BsChevronDown
            style={{ fontSize: 10, marginLeft: 5 }}
            className="arrow-down"
          />
        ) : null}
      </>
    ) : (
      title
    );
    return { key, children, label, icon };
  }
  return null;
};

export const newMenus = (items) => {
  const menu = [
    setMenuItem({ ...items?.dashboard }),
    setMenuItem({ ...items?.billing }),
  ];
  return menu;
};

export const newAuthMenu = (items, logged) => {
  const loggedin = [setMenuItem({ ...items?.account })];
  const anonymous = [
    setMenuItem({ ...items?.register }),
    setMenuItem({ ...items?.login }),
  ];
  const menu = logged === null ? [] : logged === true ? loggedin : anonymous;
  return menu;
};

export const newDashboard = (items) => {
  const operator = [items?.operators];
  const concepts = [items?.concepts, items?.approves];
  const news = [items?.newsCategory, items?.newsPost];
  const three = [items?.threeMapperListing, items?.threeMapperBrand];
  return {
    operator,
    concepts,
    news,
    three,
  };
};

EOF



cat > src/screen/00_Nav/router.js <<EOF
import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

// component
import { LoadingScreen } from "../../component/loading";
import { routePublict } from "./route/router_publict";
import { routerPrivate } from "./route/router_private";
import { useLogged } from "hook/useLogged";
import TermOfService from "screen/99_Term/term_of_service";
import DataPrivacy from "screen/98_Data_Privacy/data_privacy";
import { URL } from "./url";
import HomeScreen from "screen/01_Home/home_screen";
// redux

const Router = () => {
  // -------------------------- STATE ---------------------------
  const { logged } = useLogged();
  const to = logged ? URL.list : URL.home;
  // -------------------------- REDUX ---------------------------

  // -------------------------- EFFECT --------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- MAIN ----------------------------
  if (logged === null) {
    return <LoadingScreen />;
  }
  return (
    <BrowserRouter>
      <Routes>
        {logged ? routerPrivate() : routePublict()}
        <Route path={URL.home} element={<HomeScreen />} />
        <Route path={URL.term} element={<TermOfService />} />
        <Route path={URL.privacy} element={<DataPrivacy />} />
        <Route path="*" element={<Navigate to={to} exact replace />} />
      </Routes>
    </BrowserRouter>
  );
};

export default Router;
EOF

cat > src/screen/01_Home/home_screen.js <<EOF
import React from "react";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const HomeScreen = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return (
    <>
    </>
  );
};
export default HomeScreen;

EOF


cat > src/component/loading.js <<EOF
import React from "react";
import { Spin } from "antd";
import { LoadingOutlined } from "@ant-design/icons";

export const Loading = () => {
  return (
    <div className="loading">
      <Spin />
    </div>
  );
};

export const LoadingScreen = () => {
  return (
    <div className="fixed bottom-0 left-0 right-0 top-0 flex min-h-[100vh] items-center justify-center">
      <Spin
        size="large"
        indicator={<LoadingOutlined className="text-blue-600" />}
      />
    </div>
  );
};

EOF

cat > src/component/loading.js <<EOF
import React from "react";
import { Spin } from "antd";
import { LoadingOutlined } from "@ant-design/icons";

export const Loading = () => {
  return (
    <div className="loading">
      <Spin />
    </div>
  );
};

export const LoadingScreen = () => {
  return (
    <div className="fixed bottom-0 left-0 right-0 top-0 flex min-h-[100vh] items-center justify-center">
      <Spin
        size="large"
        indicator={<LoadingOutlined className="text-blue-600" />}
      />
    </div>
  );
};

EOF

cat > src/screen/00_Nav/app_root.js <<EOF
import React, { useEffect } from "react";
import { useDispatch } from "react-redux";
//
//component
import AppAuth from "./app_auth";
import {
  snapAuth,
  unSnapAuth,
} from "store/auth/auth.action";
//redux
//selector
//actions

//utils
//hook
//str
const AppRoot = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  const dispatch = useDispatch();
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
 
  useEffect(() => {
    dispatch(snapAuth());
    return () => {
      dispatch(unSnapAuth());
    };
  }, [dispatch]);
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return <AppAuth />;
};
export default AppRoot;
EOF



cat > src/screen/00_Nav/app_auth.js <<EOF
import React from "react";
import TriggerInit from "./trigger/trigger_init";
import Router from "./router";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const AppAuth = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return (
    <>
      <TriggerInit />
      <Router />
    </>
  );
};
export default AppAuth;

EOF


cat > src/screen/00_Nav/trigger/trigger_init.js <<EOF
//
//component
//redux
//selector
//actions
const TriggerInit = () => {
  // -------------------------- VAR ----------------------------
  // -------------------------- STATE --------------------------
  // -------------------------- REDUX --------------------------

  // -------------------------- USE EFFECT ---------------------

  // -------------------------- RETURN --------------------------
  return (
    <>
      {/* trigger auth */}

      {/* trigger route private */}
    </>
  );
};
export default TriggerInit;
EOF



cat > src/screen/00_Nav/route/router_private.js <<EOF
import React from "react";
import { Route } from "react-router-dom";
//
import { URL } from "../url";
// component
import LayoutRoot from "../layout/layout_root";
//
//concept

const PERMISSION_SCREEN = "";

export const routerPrivate = () => {
  // -------------------------- STATE --------------------------

  // -------------------------- FUNCTION --------------------------

  // -------------------------- RENDER --------------------------

  // -------------------------- MAIN --------------------------
  return (
    <Route exact path={URL.list} element={<LayoutRoot />}>
      
    </Route>
  );
};

EOF

cat > src/screen/00_Nav/route/router_publict.js <<EOF
import React from "react";
import { Route } from "react-router-dom";
import { URL } from "../url";
import SignInScene from "../../01_Login/login";
// import DevScreen from "screen/100_Dev/dev";

export const routePublict = () => {
  // -------------------------- STATE --------------------------

  // -------------------------- FUNCTION --------------------------

  // -------------------------- RENDER --------------------------

  // -------------------------- MAIN --------------------------

  return (
    <>
      <Route exact path={URL.login} element={<SignInScene />} />
      {/* <Route path={URL.dev} element={<DevScreen />} /> */}
    </>
  );
};
EOF


mkdir -p src/screen/01_Login

cat > src/screen/01_Login/login.js <<EOF
import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const LoginScreen = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return <></>;
};
export default LoginScreen;
EOF


 

cat > src/screen/99_Term/term_of_service.js <<EOF
import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const TermOfService = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return <></>;
};
export default TermOfService;
EOF


cat > src/screen/98_Data_Privacy/data_privacy.js <<EOF
import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const DataPrivacy = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return <></>;
};
export default DataPrivacy;
EOF



cat > src/screen/100_Dev/dev.js <<EOF
import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
const DevScreen = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return <></>;
};
export default DevScreen;
EOF


cat > src/screen/00_Nav/layout/layout_banned.js <<EOF
import React from "react";
import { Layout, Empty, Button, Row, Col } from "antd";
import { FiPower } from "react-icons/fi";
import { useDispatch } from "react-redux";
// redux
import { logOut } from "store/auth/auth.action";

const { Content } = Layout;
const BannedScreen = () => {
  // -------------------------- VAR --------------------------

  // -------------------------- STATE --------------------------

  // -------------------------- REDUX --------------------------
  const dispatch = useDispatch();
  // -------------------------- FUNCTION --------------------------

  const renderLogout = () => {
    return (
      <Button
        shape="default"
        onClick={() => dispatch(logOut())}
        style={{ alignSelf: "center", margin: "auto" }}
        icon={
          <span className="anticon">
            <FiPower />
          </span>
        }
      >
        Đăng xuất
      </Button>
    );
  };

  // -------------------------- EFFECT --------------------------

  // -------------------------- RENDER --------------------------

  // -------------------------- MAIN --------------------------
  return (
    <Layout className="site-layout full">
      <Content className="content">
        <Row gutter={[10, 10]}>
          <Col xs={24} sm={24} md={24} lg={24}>
            <h1 style={{ textAlign: "center" }}>Banned!</h1>
            <Empty description={false} />
            <p style={{ textAlign: "center" }}>Bạn đã bị banned.</p>
          </Col>
          <Col xs={24} sm={24} md={24} lg={24} style={{ textAlign: "center" }}>
            {renderLogout()}
          </Col>
        </Row>
      </Content>
    </Layout>
  );
};

export default BannedScreen;

EOF


cat > src/screen/00_Nav/layout/layout_footer.js <<EOF 
import React, { useState } from "react";
import { Layout, Row, Col, Typography } from "antd";

//
//component
//redux
//selector
//actions
//utils
//hook
//str
import { BRAND_NAME } from "config/config";

const LayoutFooter = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return (
    <Layout.Footer>
      <Row>
        <Col align="center" span={24}>
          <Typography.Text type="secondary">{BRAND_NAME}</Typography.Text>
        </Col>
        <Col align="center" span={24}>
          <div className="flex items-center justify-center gap-2 text-center text-gray-500">
            <a
              className="hover:text-gray-600 hover:underline"
              href="/term-of-service"
            >
              Điều khoản dịch vụ
            </a>{" "}
            |{" "}
            <a
              className="hover:text-gray-600 hover:underline"
              href="/privacy-policy"
            >
              Chính sách bảo mật
            </a>
          </div>
        </Col>
        <Col align="center" span={24}>
          <Typography.Text type="secondary">© Powered by ViVN</Typography.Text>
        </Col>
      </Row>
    </Layout.Footer>
  );
};
export default LayoutFooter;
EOF

cat > src/screen/00_Nav/layout/layout_header.js <<EOF
import React from "react";
import { Layout, Tooltip, Button, BackTop } from "antd";
import { useDispatch } from "react-redux";
import { FiMenu } from "react-icons/fi";
// component
import HeaderUser from "component/header/header_user";
//redux
import { toggleCollapse } from "../../../store/bailiff/nav/nav.action";
import logo from "../../../asset/img/logo/client.png";

const LayoutHeader = (props) => {
  // -------------------------- STATE --------------------------
  const { title } = props;
  // -------------------------- REDUX --------------------------
  const dispatch = useDispatch();
  // -------------------------- EFFECT --------------------------
  // -------------------------- FUNCTION --------------------------
  const toggleMenu = () => {
    dispatch(toggleCollapse());
  };

  // -------------------------- RENDER --------------------------

  const renderBody = () => {
    return (
      <div className="flex h-[70px] flex-row items-center justify-between bg-white">
        <div className="flex flex-row items-center gap-2">
          {renderMenu()}
          {renderTitle()}
        </div>
        <div className="hidden flex-row items-center justify-end md:block">
          {renderLogout()}
        </div>
      </div>
    );
  };

  const renderMenu = () => {
    return (
      <Tooltip title="Menu">
        <Button
          shape="default"
          onClick={() => toggleMenu()}
          icon={
            <span className="anticon">
              <FiMenu />
            </span>
          }
        />
      </Tooltip>
    );
  };

  const renderTitle = () => {
    const size = 35;
    return (
      <div className="flex h-[70px] flex-row gap-2">
        <div className="flex flex-row items-center">
          <a
            href="/"
            style={{
              display: "flex",
              alignItems: "center",
              width: size,
              height: size,
            }}
          >
            <img src={logo} style={{ width: size, height: size }} alt="logO" />
          </a>
        </div>
        <div className="flex flex-row items-center text-[16px] font-bold">
          {title || ""}
        </div>
      </div>
    );
  };

  const renderLogout = () => {
    return (
      <div style={{ paddingRight: 20 }}>
        <HeaderUser />
      </div>
    );
  };
  // -------------------------- MAIN --------------------------
  return (
    <Layout.Header className="min-h-[70px] bg-white">
      {renderBody()}
      <BackTop className="z-[99]" />
    </Layout.Header>
  );
};

export default LayoutHeader;
EOF


cat > src/screen/00_Nav/layout/layout_menu.js <<EOF
import React from "react";
import { Menu } from "antd";
import { useSelector } from "react-redux";
import { useMenu } from "../../../hook/useMenu";
import { highlightSelector } from "../../../store/nav/nav.selector";

const LayoutMenu = (props) => {
  // -------------------------- VAR --------------------------
  const { mode } = props;
  const { menu } = useMenu();
  // -------------------------- STATE --------------------------
  // -------------------------- REDUX --------------------------
  const hightlight = useSelector(highlightSelector);
  // -------------------------- EFFECT --------------------------
  // -------------------------- FUNCTION --------------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN --------------------------
  return (
    <Menu
      key={hightlight}
      mode={mode || "inline"}
      items={menu}
      selectedKeys={hightlight}
    />
  );
};

export default LayoutMenu;
EOF

cat > src/screen/00_Nav/layout/layout_root.js <<EOF
import React from "react";
import { Outlet } from "react-router-dom";
import { Layout, Drawer, Button } from "antd";
import { useSelector } from "react-redux";
// component
import LayoutMenu from "./layout_menu";
import LayoutFooter from "./layout_footer";

// redux
import { collapseSelector } from "../../../store/nav/nav.selector";
import { useDispatch } from "react-redux";
import { toggleCollapse } from "store/nav/nav.action";
import { LogoutOutlined } from "@ant-design/icons";
import { logOut } from "store/auth/auth.action";
import SEOHelmet from "component/seo/seo_helmet";

const LayoutRoot = () => {
  // -------------------------- VAR --------------------------

  // -------------------------- STATE --------------------------
  // -------------------------- REDUX --------------------------
  const dispatch = useDispatch();
  const collapsed = useSelector(collapseSelector);
  // -------------------------- EFFECT --------------------------

  // -------------------------- FUNCTION --------------------------
  const onClose = () => {
    dispatch(toggleCollapse());
  };

  const handleLogout = () => {
    dispatch(logOut());
    onClose();
  };

  // -------------------------- RENDER --------------------------
  const DrawerSection = () => {
    return (
      <Drawer
        closable={false}
        rootClassName="drawer-layout"
        styles={{ padding: 5, position: "relative" }}
        onClose={onClose}
        placement="left"
        width={260}
        open={collapsed}
      >
        <div className="logo">
          <div
            style={{
              minHeight: 60,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontWeight: "bold",
              fontSize: 20,
            }}
          >
            Thừa Phát Lại
          </div>
        </div>
        <LayoutMenu />
        <div
          style={{
            position: "absolute",
            bottom: 10,
            left: 0,
            right: 0,
            minHeight: 50,
            textAlign: "center",
          }}
        >
          <Button onClick={handleLogout} icon={<LogoutOutlined />}>
            Đăng Xuất
          </Button>
        </div>
      </Drawer>
    );
  };
  // -------------------------- MAIN --------------------------

  return (
    <Layout>
      <DrawerSection />
      <Layout>
        <Outlet />
        <LayoutFooter />
      </Layout>
      <SEOHelmet />
    </Layout>
  );
};

export default LayoutRoot;
EOF
 

cat > src/utils/auth.util.js <<EOF
const FIREBASE_AUTH_ERROR = {
  "auth/user-not-found":
    "Tài khoản không tồn tại. Vui lòng kiểm tra lại email.",
  "auth/wrong-password": "Mật khẩu không đúng. Vui lòng thử lại.",
  "auth/invalid-email": "Địa chỉ email không hợp lệ.",
  "auth/user-disabled": "Tài khoản này đã bị vô hiệu hóa.",
  "auth/email-already-in-use":
    "Email này đã được sử dụng bởi một tài khoản khác.",
  "auth/weak-password":
    "Mật khẩu quá yếu. Vui lòng chọn mật khẩu khác mạnh hơn.",
  "auth/too-many-requests":
    "Bạn đã thực hiện quá nhiều yêu cầu. Vui lòng thử lại sau.",
  "auth/network-request-failed":
    "Lỗi mạng. Vui lòng kiểm tra kết nối internet của bạn.",
  "auth/invalid-credential": "Thông tin đăng nhập không hợp lệ.",
};

export const getFirebaseAuthErrorMessage = (errorCode) => {
  return (
    FIREBASE_AUTH_ERROR[errorCode] || "Đã có lỗi xảy ra. Vui lòng thử lại."
  );
};
EOF

cat > src/utils/generate.function.js <<EOF
// ------------------------------------  Prepair Functions END  ------------------------------------
export const makeOrderId = (length) => {
  let result = "";
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  const charactersLength = characters.length;
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
};
// ------------------------------------  Prepair Functions END  ------------------------------------
export const makeCode = (length) => {
  let result = "";
  const characters = "0123456789";
  const charactersLength = characters.length;
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
};
EOF


cat > src/store/api.js <<EOF
import { getFunctions, httpsCallable } from "firebase/functions";
import { REGION } from "store/ref";
import { getApp } from "firebase/app";

const app = getApp();
const functions = getFunctions(app,REGION);

// get functions api.
export const getApiFunctions = () => {
  // :::::::::::: LOGIN :::::::::::::://

  // login operator.
  const login = httpsCallable(functions, "api-operator-login-token");


  // hàm add pin code.
  const emailSendCode = httpsCallable(
    functions,
    "api-email-verification-add-pincode",
  ); // { email, source },
  const emailCheckCode = httpsCallable(
    functions,
    "api-email-verification-check-pincode",
  ); // { email, source, pincode},

 

  // return.
  return {
    login,
    email: {
      emailSendCode,
      emailCheckCode,
    },
    
  };
};
EOF


mkdir -p src/store/auth

cat > src/store/auth/auth.action.js <<EOF
import moment from "moment";
import {
  getAuth,
  onAuthStateChanged,
  signOut,
  fetchSignInMethodsForEmail,
  createUserWithEmailAndPassword,
} from "firebase/auth";
import { TYPES } from "./auth.type";
import { SOURCE } from "config/config";
import { getApiFunctions } from "../api";
import { getApp } from "firebase/app";

const app = getApp();
const auth = getAuth(app);

// -------------------------- Snapshot --------------------------
const authSub = [];
export const snapAuth = () => (dispatch) => {
  const unSub = onAuthStateChanged(auth, async (user) => {
    const uid = user?.uid;
    const isLogged = uid ? true : false;
    const reloadUserInfo = user?.reloadUserInfo;
    const email = user?.email;
    const permissions = reloadUserInfo?.customAttributes;

    firebasePermissionSuccess(dispatch, permissions);
    firebaseEmailSuccess(dispatch, email);
    firebaseAuthSuccess(dispatch, isLogged);
    firebaseUidSuccess(dispatch, uid);
  });
  authSub.push(unSub);
};

export const unSnapAuth = () => (dispatch) => {
  authSub.forEach((subscriber) => {
    subscriber();
  });
  authSub.length = 0;
};

export const logOut = () => (dispatch) => {
  signOut(auth);
};

export const checkEmail =
  ({ register }, callback) =>
  (dispatch) => {
    const email = register.email;
    console.log({ email });
    return fetchSignInMethodsForEmail(auth, email)
      .then((response) => {
        console.log({ response });
        if (response.length === 0) {
          if (callback) {
            callback({
              status: 200,
            });
          }
          firebaseRegisterSuccess(dispatch, register);
        } else {
          callback({
            status: 500,
            data: "Email này đã được sử dụng, xin vui lòng đăng ký email khác",
          });
        }
      })
      .catch((error) => console.log({ error }));
  };

export const registerEmailPassword =
  ({ register }, callback) =>
  (dispatch) => {
    const email = register.email;
    const password = register.password;
    createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        const user = userCredential.user;
        if (callback) {
          callback({
            status: 200,
            data: user,
          });
        }
      })
      .catch((error) => {
        const code = error?.code;
        if (code === "auth/email-already-in-use") {
          callback &&
            callback({
              status: 500,
              data: "Email này đã được sử dụng, xin vui lòng đăng ký email khác",
            });
        } else {
          callback &&
            callback({
              status: 500,
              data: error.code,
            });
        }
      });
  };

// ================ CLOUD FUNCTIONS ==================== //

export const sendEmail =
  ({ email }, callback) =>
  (dispatch) => {
    const apiEmailVerify = getApiFunctions().email.emailSendCode;
    apiEmailVerify({ email, source: SOURCE })
      .then((response) => {
        console.log({ response });
        const data = response.data;
        const lastSent = moment().toDate();
        firebaseGetLastMailSuccess(dispatch, lastSent);
        if (callback) {
          callback({ status: 200, data });
        }
      })
      .catch((err) => {
        callback({ status: 500, data: err?.message || "Invalid Error" });
      });
  };

export const verifyEmail =
  ({ email, pincode }, callback) =>
  (dispatch) => {
    const apiEmailVerify = getApiFunctions().email.emailCheckCode;
    apiEmailVerify({ email, pincode, source: SOURCE })
      .then((response) => {
        const data = response.data;
        if (callback) {
          callback({ status: 200, data });
        }
      })
      .catch((err) => {
        console.log({ err });
        callback({ status: 500, data: err?.message || "Invalid Error" });
      });
  };

export const setStepRegister = (step) => (dispatch) => {
  setRegisterStepSuccess(dispatch, step);
};

// -------------------------- Dispatch --------------------------
const firebaseAuthSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_STATUS,
    payload: data,
  });
};

const firebaseUidSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_UID,
    payload: data,
  });
};

const firebasePermissionSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_PERMISSIONS,
    payload: data,
  });
};

const firebaseRegisterSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_REGISTER_SUCCESS,
    payload: data,
  });
};

const setRegisterStepSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_REGISTER_STEP,
    payload: data,
  });
};

const firebaseGetLastMailSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_REGISTER_LASTMAIL,
    payload: data,
  });
};

const firebaseEmailSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.FIREBASE_AUTH_EMAIL,
    payload: data,
  });
};

EOF



cat > src/store/auth/auth.reducer.js <<EOF

import { TYPES } from "./auth.type";

const initState = {
  isLogged: null,
  uid: null,
  email: null,
  displayName: null,
  photoURL: null,
  permissions: [],
  //
  register: null,
  step: 0,
  lastMail: null,
};

const authReducer = (state = initState, action) => {
  const { type, payload } = action;
  switch (type) {
    case TYPES.FIREBASE_AUTH_STATUS:
      return {
        ...state,
        isLogged: payload,
      };

    case TYPES.FIREBASE_AUTH_EMAIL:
      return {
        ...state,
        email: payload,
      };

    case TYPES.FIREBASE_AUTH_DISPLAYNAME:
      return {
        ...state,
        displayName: payload,
      };

    case TYPES.FIREBASE_AUTH_PHOTOURL:
      return {
        ...state,
        photoURL: payload,
      };

    case TYPES.FIREBASE_AUTH_UID:
      return {
        ...state,
        uid: payload,
      };
    case TYPES.FIREBASE_AUTH_PERMISSIONS:
      return {
        ...state,
        permissions: payload,
      };
    case TYPES.FIREBASE_AUTH_REGISTER_SUCCESS:
      return {
        ...state,
        register: payload,
      };
    case TYPES.FIREBASE_AUTH_REGISTER_STEP:
      return {
        ...state,
        step: payload,
      };
    case TYPES.FIREBASE_AUTH_REGISTER_LASTMAIL:
      return {
        ...state,
        lastMail: payload,
      };
    default:
      return state;
  }
};

export default authReducer;
EOF


cat > src/store/auth/auth.selector.js <<EOF
export const isLoggedSelector = (state) => state.authReducer.isLogged;
export const uidSelector = (state) => state.authReducer.uid;
export const emailSelector = (state) => state.authReducer.email;
export const displayNameSelector = (state) => state.authReducer.displayName;
export const photoURLSelector = (state) => state.authReducer.photoURL;
export const permissionsSelector = (state) => state.authReducer.permissions;
//
export const registerSelector = (state) => state.authReducer.register;
export const registerStepSelector = (state) => state.authReducer.step;
export const registerLastMailSelector = (state) =>
  state.authReducer.lastMail;
EOF


cat > src/store/auth/auth.type.js <<EOF
export const TYPES = {
  FIREBASE_AUTH_STATUS: "auth/FIREBASE_AUTH_STATUS",
  FIREBASE_AUTH_UID: "auth/FIREBASE_AUTH_UID",
  FIREBASE_AUTH_EMAIL: "auth/FIREBASE_AUTH_EMAIL",
  FIREBASE_AUTH_DISPLAYNAME: "auth/FIREBASE_AUTH_DISPLAYNAME",
  FIREBASE_AUTH_PHOTOURL: "auth/FIREBASE_AUTH_PHOTOURL",
  FIREBASE_AUTH_PERMISSIONS: "auth/FIREBASE_AUTH_PERMISSIONS",
  //
  FIREBASE_AUTH_REGISTER_SUCCESS: "auth/FIREBASE_AUTH_REGISTER_SUCCESS",
  FIREBASE_AUTH_REGISTER_STEP: "auth/FIREBASE_AUTH_REGISTER_STEP",
  FIREBASE_AUTH_REGISTER_LASTMAIL: "auth/FIREBASE_AUTH_REGISTER_LASTMAIL",
};
EOF


cat > src/store/auth/auth.type.js <<EOF
export const TYPES = {
  FIREBASE_AUTH_STATUS: "auth/FIREBASE_AUTH_STATUS",
  FIREBASE_AUTH_UID: "auth/FIREBASE_AUTH_UID",
  FIREBASE_AUTH_EMAIL: "auth/FIREBASE_AUTH_EMAIL",
  FIREBASE_AUTH_DISPLAYNAME: "auth/FIREBASE_AUTH_DISPLAYNAME",
  FIREBASE_AUTH_PHOTOURL: "auth/FIREBASE_AUTH_PHOTOURL",
  FIREBASE_AUTH_PERMISSIONS: "auth/FIREBASE_AUTH_PERMISSIONS",
  //
  FIREBASE_AUTH_REGISTER_SUCCESS: "auth/FIREBASE_AUTH_REGISTER_SUCCESS",
  FIREBASE_AUTH_REGISTER_STEP: "auth/FIREBASE_AUTH_REGISTER_STEP",
  FIREBASE_AUTH_REGISTER_LASTMAIL: "auth/FIREBASE_AUTH_REGISTER_LASTMAIL",
};
EOF


mkdir -p src/store/login

cat > src/store/login/login.action.js <<EOF
import {
  getAuth,
  signInWithEmailAndPassword,
  signOut,
  createUserWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
} from "firebase/auth";
import { TYPES } from "./login.types";
import { getApp } from "firebase/app";
import { getFirebaseAuthErrorMessage } from "util/auth.util";

const app = getApp();
const auth = getAuth(app);
const provider = new GoogleAuthProvider();
provider.addScope("email");

// -------------------------- LOGIN --------------------------
export const firebaseLogin =
  ({ login }, callback) =>
  async (dispatch) => {
    firebaseLoading(dispatch);
    const email = login.email;
    const password = login.password;

    return loginWithAdmin({ email, password, dispatch, callback });
  };

// By Admin
const loginWithAdmin = ({ email, password, dispatch, callback }) => {
  signInWithEmailAndPassword(auth, email, password)
    .then(() => {
      if (callback) {
        callback({
          status: 200,
          data: "Đăng nhập thành công",
        });
      }
    })
    .catch((error) => {
      const errorMessage = getFirebaseAuthErrorMessage(error.code);
      if (callback) {
        callback({
          status: 500,
          data: errorMessage,
        });
      }
    });
};

// tạo auth mới.
export const createNewAccount =
  ({ email, password }, callback) =>
  (dispatch) => {
    const auth = getAuth();
    createUserWithEmailAndPassword(auth, email, password)
      .then(() => {
        callback && callback({ status: 200 });
      })
      .catch((err) => {
        console.log({ err });
        const errorMessage = getFirebaseAuthErrorMessage(err.code);
        callback && callback({ status: 500, data: errorMessage });
      });
  };

// đăng nhập với google.
export const firebaseLoginWithGoogle = (callback) => (dispatch) => {
  return signInWithPopup(auth, provider)
    .then((user) => {
      if (user) {
        console.log({ user });
        callback && callback({ status: 200 });
      }
    })
    .catch((err) => {
      console.log({ err });
      const errorMessage = getFirebaseAuthErrorMessage(err.code);
      callback &&
        callback({ status: 500, data: errorMessage || "Please try again!" });
    });
};

// -------------------------- Logout --------------------------

export const firebaseLogout = (callback) => (dispatch) => {
  signOut(auth).then(() => {});
  firebaseLogoutSuccess(dispatch);
  if (callback) {
    callback();
  }
};

export const setLoadingSuccess = () => (dispatch) => {
  firebaseLogoutSuccess(dispatch);
};

// -------------------------- Dispatch --------------------------

const firebaseLoading = (dispatch) => {
  dispatch({
    type: TYPES.LOGIN_LOADING,
  });
};

const firebaseLogoutSuccess = (dispatch) => {
  dispatch({
    type: TYPES.LOGOUT_SUCCESS,
  });
};
EOF


cat > src/store/login/login.reducer.js <<EOF
import { TYPES } from "./login.types";

const initState = {
  error: "",
  loading: false,
};

const loginReducer = (state = initState, action) => {
  const { type, payload } = action;
  switch (type) {
    case TYPES.LOGIN_LOADING:
      return {
        ...state,
        loading: true,
      };
    case TYPES.LOGIN_SUCCESS:
      return {
        ...state,
        error: "",
        loading: false,
      };
    case TYPES.LOGIN_FAILED:
      return {
        ...state,
        error: payload,
        loading: false,
      };
    default:
      return state;
  }
};

export default loginReducer;
EOF


cat > src/store/login/login.types.js <<EOF
export const TYPES = {
  LOGIN_LOADING: "login/LOGIN_LOADING",
  LOGIN_SUCCESS: "login/LOGIN_SUCCESS",
  LOGIN_FAILED: "login/LOGIN_FAILED",
  LOGOUT_SUCCESS: "login/LOGOUT_SUCCESS",
};
EOF

cat > src/store/login/login.selector.js <<EOF
export const loadingSelector = (state) => state.loginReducer.loading;
EOF

mkdir -p src/store/nav

cat > src/store/nav/nav.action.js <<EOF
import { TYPES } from "./nav.types";

// -------------------------- Snapshot --------------------------
export const toggleExpanse = () => (dispatch) => {
  toggleExpanseSuccess(dispatch);
};

export const toggleCollapse = () => (dispatch) => {
  toggleCollapseSuccess(dispatch);
};

export const setHighlight = (keys) => (dispatch) => {
  setHightLightSuccess(dispatch, keys);
};

// -------------------------- Dispatch --------------------------
const toggleExpanseSuccess = (dispatch) => {
  dispatch({
    type: TYPES.EXPANSE,
  });
};

const toggleCollapseSuccess = (dispatch) => {
  dispatch({
    type: TYPES.COLLAPSE,
  });
};

const setHightLightSuccess = (dispatch, data) => {
  dispatch({
    type: TYPES.HIGHTLIGHT,
    payload: data,
  });
};
EOF

cat > src/store/nav/nav.reducer.js <<EOF
import { TYPES } from "./nav.types";

const initState = {
  expansed: true,
  collapsed: false,
  hightlight: [],
};

const navReducer = (state = initState, action) => {
  const { type, payload } = action;
  switch (type) {
    case TYPES.EXPANSE:
      return {
        ...state,
        expansed: !state.expansed,
      };
    case TYPES.COLLAPSE:
      return {
        ...state,
        error: payload,
        collapsed: !state.collapsed,
      };
    case TYPES.HIGHTLIGHT:
      return {
        ...state,
        hightlight: payload,
      };
    default:
      return state;
  }
};

export default navReducer;
EOF


cat > src/store/nav/nav.selector.js <<EOF
export const expanseSelector = (state) => state.navReducer.collapsed;
export const collapseSelector = (state) => state.navReducer.collapsed;
export const highlightSelector = (state) => state.navReducer.hightlight;
EOF


cat > src/store/nav/nav.types.js <<EOF
export const TYPES = {
  EXPANSE: "nav/EXPANSE",
  COLLAPSE: "nav/COLLAPSE",
  HIGHTLIGHT: "nav/HIGHTLIGHT",
};
EOF


cat > jsconfig.json <<EOF
{
  "compilerOptions": {
    "baseUrl": "src"
  },
  "include": ["src"]
}
EOF


mkdir -p src/component/seo


cat > src/component/seo/seo_helmet.js <<EOF
import React from "react";
import { Helmet } from "react-helmet";

const SEOHelmet = ({
  title = "Project",
  description = "",
  keywords = "",
  author = "Robert Lee",
  canonical,
  ogImage,
  ogType = "website",
  twitterCard = "summary_large_image",
  noIndex = false,
  siteUrl = "",
}) => {
  // Tạo URL canonical nếu không được cung cấp
  const canonicalUrl = canonical || "";

  // Tạo URL cho hình ảnh OG nếu không được cung cấp
  const ogImageUrl = ogImage || "";

  // Tạo thẻ meta robots
  const robotsContent = noIndex ? "noindex, nofollow" : "index, follow";

  return (
    <Helmet>
      {/* Meta tags cơ bản */}
      <title>{title}</title>
      <meta name="description" content={description} />
      {keywords && <meta name="keywords" content={keywords} />}
      <meta name="author" content={author} />
      <link rel="canonical" href={canonicalUrl} />

      {/* Open Graph tags */}
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:type" content={ogType} />
      <meta property="og:url" content={canonicalUrl} />
      <meta property="og:image" content={ogImageUrl} />
      <meta property="og:site_name" content="Thừa Phát Lại Support" />

      {/* Twitter Card tags */}
      <meta name="twitter:card" content={twitterCard} />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={ogImageUrl} />

      {/* Robots */}
      <meta name="robots" content={robotsContent} />

      {/* Thẻ bổ sung */}
      <meta name="theme-color" content="#4285f4" />
    </Helmet>
  );
};

export default SEOHelmet;
EOF


cat > postcss.config.js <<EOF
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF


cat > tailwind.config.js <<EOF
  /** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js}"],
  plugins: [],
};

EOF
 

cat > .prettierrc <<EOF
{
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOF

cat > src/hook/useToken.js <<EOF
import { useSelector } from "react-redux";
import { permissionsSelector } from "store/auth/auth.selector";
//
//component
//redux
//selector
//actions
//utils
//hook
//str
export const useClaimToken = () => {
  // -------------------------- VAR -----------------------------
  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  const claim = useSelector(permissionsSelector);
  const permissions = claim ? JSON.parse(claim)?.clients : [];

  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return { permissions };
};
EOF

cat > .gitignore <<EOF
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

#agent
.agent

# production
/build

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

 
echo "--------------------------------------------------"
echo -e "\e[HOÀN TẤT CẤU HÌNH V2]"
echo "- Cấu trúc thư mục đã được tinh gọn lại."
echo -e "Store default đã setup sẵn Firestore và Redux Toolkit."
echo "--------------------------------------------------"
