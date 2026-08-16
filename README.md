# OpenWrt + Passwall Build Setup Script

## فارسی

### این اسکریپت چیکار می‌کنه
اسکریپت `setup_openwrt_passwall.sh` محیط لازم برای بیلد فرم‌ور OpenWrt (نسخه‌ی 24.10.7) رو روی یک سرور لینوکسی مبتنی بر Debian/Ubuntu آماده می‌کنه و فید Passwall رو هم به فایل `feeds.conf.default` اضافه می‌کنه. مراحلش به ترتیب:

1. `apt update`
2. نصب پکیج‌های مورد نیاز بیلد OpenWrt (`build-essential`, `git`, `gawk`, ...)
3. کلون کردن ریپازیتوری `openwrt/openwrt`
4. چک‌اوت تگ `v24.10.7`
5. اضافه‌کردن دو خط فید Passwall به `feeds.conf.default` (اگر از قبل نباشن)
6. `./scripts/feeds update -a`
7. `./scripts/feeds install -a`

هر مرحله بعد از اجرا چک می‌شه؛ اگر هرکدوم شکست بخوره، اسکریپت با یه پیام خطای واضح متوقف می‌شه و مرحله‌های بعدی اجرا نمی‌شن.

### پیش‌نیازها
- یک سرور/ماشین لینوکسی مبتنی بر Debian یا Ubuntu (بیلد OpenWrt باید روی یک ماشین لینوکسی معمولی انجام بشه، نه روی خودِ روتر)
- دسترسی `sudo`
- اتصال اینترنت پایدار (کلون‌کردن ریپازیتوری OpenWrt و فیدها حجم نسبتاً زیادی داره)

### نحوه‌ی اجرا

**روش ۱ - کلون کردن ریپازیتوری:**
```bash
git clone <https://github.com/allami86x/Openwrt-builder/>
cd <Openwr-Builder>
chmod +x setup_openwrt_passwall.sh
./setup_openwrt_passwall.sh
```

**روش ۲ - اجرای مستقیم با یک خط دستور:**
```bash
curl -fsSL https://raw.githubusercontent.com/allami86x/Openwrt-builder/main/setup_openwrt_passwall.sh | bash
```

⚠️ قبل از اجرای مستقیم با `curl | bash`، بهتره یه‌بار خودِ فایل رو بخونی. این روش یعنی هرچی الان توی اون لینک باشه، بدون بازبینی روی سیستمت اجرا می‌شه.

### نکات فنی
- پکیج `python3-distutils` روی اوبونتوی 22.04 به بالا و دبیان‌های جدید (پایتون 3.12+) از مخازن رسمی حذف شده. اسکریپت قبل از نصب چک می‌کنه این پکیج موجوده یا نه؛ اگر نبود، فقط با یه هشدار ازش رد می‌شه و بقیه‌ی نصب رو خراب نمی‌کنه.
- نسخه با تگ گیت `v24.10.7` چک‌اوت می‌شه (نه `openwrt-24.10.7`).
- این اسکریپت فقط محیط بیلد رو آماده می‌کنه و فیدها رو نصب می‌کنه؛ خودِ کامپایل (`make menuconfig`، `make`) رو انجام نمی‌ده.

---

## English

### What this script does
`setup_openwrt_passwall.sh` sets up the environment needed to build OpenWrt firmware (release 24.10.7) on a Debian/Ubuntu-based Linux server, and adds the Passwall feed to `feeds.conf.default`. Steps, in order:

1. `apt update`
2. Install OpenWrt build dependencies (`build-essential`, `git`, `gawk`, ...)
3. Clone the `openwrt/openwrt` repository
4. Check out the `v24.10.7` tag
5. Add the two Passwall feed lines to `feeds.conf.default` (if not already present)
6. `./scripts/feeds update -a`
7. `./scripts/feeds install -a`

Each step is checked after it runs; if any step fails, the script stops with a clear error message and skips the remaining steps.

### Prerequisites
- A Debian- or Ubuntu-based Linux server/machine (OpenWrt must be built on a regular Linux machine, not on the router itself)
- `sudo` access
- A stable internet connection (cloning the OpenWrt repo and feeds involves a fair amount of data)

### Usage

**Option 1 - clone the repo:**
```bash
git clone <https://github.com/allami86x/Openwrt-builder>
cd <Openwrt-builder>
chmod +x setup_openwrt_passwall.sh
./setup_openwrt_passwall.sh
```

**Option 2 - run directly with a one-liner:**
```bash
curl -fsSL https://raw.githubusercontent.com/allami86x/Openwrt-builder/main/setup_openwrt_passwall.sh | bash
```

⚠️ Before running it directly via `curl | bash`, it's worth reading the script once. This method executes whatever is currently at that URL without review.

### Technical notes
- `python3-distutils` was removed from the official repos on Ubuntu 22.04+ and newer Debian releases (Python 3.12+). The script checks whether the package is available before installing, and simply warns and skips it instead of breaking the whole install if it's missing.
- The release is checked out using the git tag `v24.10.7` (not `openwrt-24.10.7`).
- This script only sets up the build environment and installs the feeds; it does not run the actual compile step (`make menuconfig`, `make`).
