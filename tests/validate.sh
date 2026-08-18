#!/usr/bin/env bash
# 策展版校验(v1.13.0 重写):只保留六类高价值断言,不再逐 release 累加字符串守卫。
# 新增守卫仅限:入口同步 / 证据状态 / 文件存在 / 母版完整性。
set -euo pipefail
trap 'echo "Validation failed at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------- 1. 文件存在 ----------
required_files=(
  "README.md" "SKILL.md" "VERSION"
  "references/shared-principles.md" "references/input-schema.md"
  "references/longform-performance-pattern.md" "references/performance-lexicon.md"
  "references/acting-craft.md" "references/acting-core.md"
  "references/actor-cut.md" "references/narrative-performance.md"
  "references/camera-direction.md" "references/interaction-performance.md"
  "references/dialogue-listening.md" "references/climax-failures.md"
  "references/kling-motion-control.md" "references/quality-gates.md"
  "references/performance-review.md" "references/evidence-ledger.md"
  "adapters/adapter-contract.md" "adapters/seedance-2.md"
  "adapters/seedance-2.5.md" "adapters/kling-3.md"
  "templates/sd25-30s-ots-emotion.md" "templates/sd25-30s-ots-argument.md"
  "templates/anchoring.md"
  "templates/official-exemplars.md"
  "tests/fixtures/seedance25-30s-farewell-monologue.verified.md"
  "tests/fixtures/seedance25-30s-argument-oscillating.verified.md"
  "tests/fixtures/seedance25-30s-argument-oscillating-zh.verified.md"
  "tests/fixtures/kling3-standard-stationary-reunion.verified.md"
)
for path in "${required_files[@]}"; do
  test -s "${skill_root}/${path}" || { echo "Missing or empty: ${path}" >&2; exit 1; }
done

# SKILL.md 引用的本地文件必须存在(防断链)
while IFS= read -r ref; do
  test -e "${skill_root}/${ref}" || { echo "Broken local reference in SKILL.md: ${ref}" >&2; exit 1; }
done < <(grep -oE '`(references|adapters|templates|tests)/[^`]+\.md`' "${skill_root}/SKILL.md" | tr -d '`' | sort -u)

# ---------- 2. 版本同步 ----------
grep -q '^name: ai-character-performance-director$' "${skill_root}/SKILL.md"
grep -q '^VERSION_NAME=1\.14\.2$' "${skill_root}/VERSION"
grep -q '^VERSION_CODE=11402$' "${skill_root}/VERSION"
grep -q '当前版本：`1.14.2`；version code：`11402`' "${skill_root}/README.md"

# ---------- 3. 入口同步(第一入口必须追踪下游状态) ----------
sk="${skill_root}/SKILL.md"
grep -q '\[USER-SD25-01\]' "${sk}"                       # 置信度段引用最新验证证据
grep -q '\[USER-SD25-02\]' "${sk}"
grep -q '① 母版实例化（最高优先）' "${sk}"                 # 三路径路由
grep -q '② 锚定转写' "${sk}"
grep -q 'templates/sd25-30s-ots-emotion.md' "${sk}"
grep -q 'templates/sd25-30s-ots-argument.md' "${sk}"
grep -q 'templates/anchoring.md' "${sk}"
grep -q 'templates/official-exemplars.md' "${sk}"
grep -q '双锚制' "${sk}"
grep -q '验收三问' "${sk}"
grep -q '`evidence-ledger` 不进入生成路径' "${sk}"
grep -q '质量门分档执行' "${sk}"
grep -q '16–30 秒' "${sk}"
grep -q '每镜 ≥6 秒' "${sk}"
grep -q '同时输出 \*\*Seedance 2\.5\*\* 与 Kling 3\.0 两版' "${sk}"

# ---------- 4. 母版完整性 ----------
etpl="${skill_root}/templates/sd25-30s-ots-emotion.md"
atpl="${skill_root}/templates/sd25-30s-ots-argument.md"
afix="${skill_root}/tests/fixtures/seedance25-30s-argument-oscillating-zh.verified.md"
anch="${skill_root}/templates/anchoring.md"
# 争吵母版正文与验证存档逐字一致
diff <(awk '/^```text$/,/^```$/' "${atpl}") <(awk '/^```text$/,/^```$/' "${afix}") >/dev/null || {
  echo "Argument master body drifted from verified fixture" >&2; exit 1; }
# 母版标签按各自实测原文校验(告别族=对白：,争吵族=她说：);台词：均不得出现
grep -q '对白：' "${etpl}"
grep -q '她说：' "${atpl}"
for t in "${etpl}" "${atpl}"; do
  test "$(grep -c '台词：' "${t}")" -eq 0
done
test "$(grep -c '【对白槽' "${etpl}")" -eq 0
grep -q '只替换引号内的句子' "${etpl}"
grep -q '对方回应槽 R1/R2' "${atpl}"
grep -q '按实测原样逐字保留' "${atpl}"
# 锚定规则完整
grep -q '质感声纹清单' "${anch}"
grep -q '结构锚' "${anch}"
for step in 'Step 0 选锚' 'Step 1 内容推导' 'Step 2 语义对位替换' 'Step 3 官方合规校验' 'Step 4 输出前核对'; do
  grep -q "${step}" "${anch}"
done

# 官方范本库完整性
ex="${skill_root}/templates/official-exemplars.md"
for e in '熊猫幼崽' '冬夜递书' '火箭告别' '宿舍短剧' '悬崖对手戏' '灵鱼' '像素武侠'; do
  grep -q "${e}" "${ex}" || { echo "Missing official exemplar: ${e}" >&2; exit 1; }
done
grep -q '不承载用户口味' "${ex}"

# ---------- 5. 证据状态 ----------
el="${skill_root}/references/evidence-ledger.md"
grep -q '本文件\*\*不进入生成路径\*\*' "${el}"
for id in USER-SD25-01 USER-SD25-02 USER-SD25-03 USER-SD20-01 USER-K3-01 USER-K3-02 USER-K3-03 USER-K3-04; do
  grep -A3 "^### \[${id}\]" "${el}" | grep -q '状态：`user_verified`' || {
    echo "Evidence ${id} missing or not user_verified" >&2; exit 1; }
done
for id in USER-TEMPLATE-01 USER-STYLE-01 USER-FORMAT-01 USER-PROMPT-01 USER-POLICY-01 USER-CRAFT-01 USER-CRAFT-02 USER-INTERACTION-01 USER-CAMERA-01; do
  grep -A3 "^### \[${id}\]" "${el}" | grep -q '状态：`user_approved`' || {
    echo "Evidence ${id} missing or not user_approved" >&2; exit 1; }
done
for id in S25-CAP-01 S25-FORMULA-01 S20-FMT-01 S25-EXEMPLAR-01 K-I2V-01 K-MC-01 K-CAM-01 K-MS-02 S2-CAM-01; do
  grep -q "\[${id}\]" "${el}" || { echo "Missing official evidence: ${id}" >&2; exit 1; }
done

# ---------- 6. 核心内容不变量(策展,不逐 release 累加) ----------
grep -q '一律用结构化分镜格式' "${sk}"                    # 全类型结构化分镜
grep -q '每条 Prompt 必须独立自足' "${sk}"                # 自足性
grep -q '构图/视角/景别' "${sk}"                          # 构图必写
grep -q '输出前逐项核对' "${sk}"                          # 需求覆盖
grep -q '不带说明后缀' "${sk}"                            # [USER-FORMAT-01]
if grep -Eq '刺激 → 第一次变化 → 结束状态|基线 → 刺激 → 处理 → 行动/选择 → 结束状态' "${sk}"; then
  echo "SKILL.md contains the legacy emotion-state timing chain." >&2; exit 1
fi
grep -q '2.0 的 Shot 标题不写时间标注' "${skill_root}/adapters/seedance-2.md"
grep -q '不用连续 prose 段落' "${skill_root}/adapters/seedance-2.md"
grep -q '响应整数秒时间戳' "${skill_root}/adapters/seedance-2.5.md"
grep -q '官方四段结构' "${skill_root}/adapters/seedance-2.5.md"
grep -q '时间前不得添加“约”' "${skill_root}/adapters/kling-3.md"
grep -q 'Motion Control 不是相机路径控制' "${skill_root}/adapters/kling-3.md"
grep -q '解释性情绪注解是已验证样式' "${skill_root}/references/acting-core.md"
grep -q '仅限不同族场景' "${skill_root}/references/performance-lexicon.md"
grep -q '词条按通道索引,不按情绪索引' "${skill_root}/references/performance-lexicon.md"
lp="${skill_root}/references/longform-performance-pattern.md"
grep -q '每镜 ≥6s' "${lp}"
grep -q '多片输出,不砍内容' "${lp}"
grep -q '设计边界' "${lp}"
grep -q '已被真实母版取代并删除' "${lp}"
grep -q '分档执行' "${skill_root}/references/quality-gates.md"
grep -q '^## H\. Prompt 自足性与必写项' "${skill_root}/references/quality-gates.md"
grep -q '本场显式设计、写明动机的运镜—情绪耦合是合法的' "${skill_root}/references/camera-direction.md"
grep -q '\[EXT-OBS-01\]' "${skill_root}/references/evidence-ledger.md"
grep -A2 '^### \[EXT-OBS-01\]' "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`experimental`'
grep -q '人物小传块' "${skill_root}/references/longform-performance-pattern.md"
grep -q '峰值即斩' "${skill_root}/references/longform-performance-pattern.md"

echo "Skill structure and required contracts are valid."
