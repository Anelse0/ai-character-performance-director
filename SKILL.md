---
name: ai-character-performance-director
description: 把角色意图、关系、刺激、情绪、对白、环境与镜头限制，转换为有戏剧行动、功能性运镜、可观察且非模板化的 AI 视频提示词（默认 Seedance 2.0 与 Kling 3.0），并可根据成片定位失效 Beat 或 Camera Unit 做定向修正。凡涉及 AI 角色演技、微表演、听戏、台词、角色互动、情绪高潮、运镜设计、演员与镜头协同、空镜航拍建立镜头、短场景镜头语言，或成片演技/镜头评价及对应 Prompt 时使用；完整故事扩写、长场景 coverage 或全片分镜不使用。
---

# AI Character Performance Director

把“角色感到什么”先转换成“角色正对谁采取什么行动、希望改变什么”，再决定观众从哪里、为何保持或移动、最后看见什么。情绪是行动成功、受阻或改变策略后的场景结果；镜头运动是信息、关系、空间或导演视点变化的结果，不是固定情绪特效。

## 工作边界

本 skill 负责表演策略、单镜或 15 秒内微序列的镜头设计、模型 Prompt 渲染，以及用户提供成片后的定向反馈；不负责扩写完整故事、制作长场景 coverage 或全片分镜，也不替用户决定无关的美术风格。若用户已提供剧情，只补足表演与镜头成立所必需的信息。

**设计立场**：细粒度编排服务于 Prompt 自洽与失效可定位（成片出问题时能回到具体 Beat 或 Camera Unit 修正），不承诺成片逐项服从模型。设计立场与跨文件共享规则的权威表述见 `references/shared-principles.md`。

**置信度**：已有真实成片验证——Kling 3.0 Standard 单人 `actor_cut`（`[USER-K3-01]`~`[USER-K3-04]`）、Seedance 2.5 30s 单人情绪表演两条（`[USER-SD25-01]` 单一情绪递进、`[USER-SD25-02]` 受激分层递进；均为夜内景/越肩/关系戏窄域）；`environment`（空镜/航拍）、`narrative` 多镜多人与双人情绪交流目前只有自测，无真实生成验证，按设计级（experimental）置信度输出。最新状态以 `references/evidence-ledger.md` 的“能力核实与验证覆盖”为准。

支持三种模式：

- `actor_cut`：摄影机主要对着一个演员，表演本身是内容。可含无声反应、独白、短台词、画外刺激与听戏。
- `narrative`：人物行动实际改变剧情、关系、信息、距离、物件归属或决定。可含多人互动、对白和多镜头。
- `environment`：空镜、航拍、建立镜头或场景介绍；没有主要演员时，以空间、社会关系、规模、入口或伏笔承担镜头责任。

用户明确写“演员 Cut / Actor Cut / 剧情表演 / 空镜 / 航拍 / 建立镜头”时服从指定；否则自动判断。模式判断不确定且结果会实质不同时，只问一个简短问题。

## 路由表（唯一路由）

先判定：**任务**（生成/评价）×**模式**（角色/环境）×**档位**（fast/standard/deep）。档位标准：

- **快车道 fast**：单人单镜、≤8 秒、`actor_cut` 或单一空镜；无交互、无对白、无复杂/接触动作、无实体硬排除。
- **标准 standard**：7–30 秒（16–30 秒仅限 Seedance 2.5 直出）、有可定位反馈或一次策略调整、单一交互或短对白。
- **复杂 deep**：多人冲突、高潮阈值、物体交换/持续接触、实体硬排除、Motion Control、多镜序列。

不确定取低一档；结果会实质不同时只问一个简短问题。按下表**逐行按序读取**（括号内为跳过的小节；来源登记/证据基础类小节只在审计时读）：

**生成分三条路径，按优先级判定**：①**母版实例化**（精确命中已验证族）→ ②**锚定转写**（同域但不精确命中）→ ③**规则重组**（其余场景，按档位行）。质量确定性从 ① 到 ③ 递减；能走前一条就不走后一条。

| 任务 | 必读（按序） |
|---|---|
| **① 母版实例化（最高优先）** | 命中 `templates/` 下某个母版触发条件时，**只读该母版并按其实例化规则改槽位，其余逐字保留**。当前母版：`templates/sd25-30s-ots-emotion.md`（告别/单向递进族）、`templates/sd25-30s-ots-argument.md`（争吵/受激分层族）。仅当用户明确要求偏离该族时降级 |
| **② 锚定转写** | 关系情绪戏（单主体/越肩/SD2.5 类）但不精确命中母版（重逢/告白/嫉妒等新场景）：读最近母版全文 ＋ `templates/anchoring.md`，按其 Step 0–4 转写；深层 reference 只在偏离锚机制时作仲裁。产物标 experimental，待成片验证 |
| ③ 角色生成 fast | `shared-principles` → `acting-craft`（§2–6，light 深度）→ 模式 ref（`actor-cut` 或 `narrative-performance`）→ 目标适配器 |
| 角色生成 standard | `shared-principles` → `acting-craft`（跳过 §11 来源登记）→ `acting-core` → 模式 ref → `camera-direction`（跳过 §2 证据基础）→ 目标适配器 |
| 角色生成 deep | standard 全部 ＋ `quality-gates` 全量逐项 |
| 环境生成 | `shared-principles` → `camera-direction`（跳过 §2）→ 目标适配器；deep 加 `quality-gates` 全量 |
| 成片评价 / 定向修正 | `performance-review` → 模式 ref → `camera-direction` → `quality-gates`（§G＋涉事小节）→ `evidence-ledger`；需要修正版 Prompt 时诊断后回到对应生成行 |
| 证据登记 / 审计 | `evidence-ledger`（含各文件的来源登记小节） |

**按需叠加**（任何档位，命中即读）：

- 情绪表演（≥15s 或涉及形态选择）：`references/longform-performance-pattern.md`（形态选择器：单一情绪递进/受激分层递进已验证，双人为设计级；短时长情绪反转不作为形态）；写 L4 外化措辞时查 `references/performance-lexicon.md`（词条不回答“演什么”，只回答“怎么写准”）
- 交互/接触/物体交换/镜头表面动作/实体硬排除，或成片出现实体增生与动作误读：`references/interaction-performance.md`
- 对白、画外音、听戏或多人话轮：`references/dialogue-listening.md`
- 崩溃、强忍泪、压抑愤怒、表白、分手等阈值场面：`references/climax-failures.md`
- Kling 复杂动作、转头情绪、精确复现或 Motion Control：`references/kling-motion-control.md`
- 适配器：Seedance 2.5 → `adapters/seedance-2.5.md`；Seedance 2.0 → `adapters/seedance-2.md`；Kling → `adapters/kling-3.md`；扩展新模型 → `adapters/adapter-contract.md`

**质量门分档执行**：所有档位常驻执行**核心程序**——需求逐项核对、Prompt 自足性与必写项、默认输出契约（三者已内嵌于本文件“默认输出”节，无需加载 `quality-gates.md`）；`quality-gates.md` 的 A–H 细则清单仅在 **deep 档与成片评价**时逐项过。

**`evidence-ledger` 不进入生成路径**：生成所需的模型结论已写入各适配器与 reference；账本仅在成片评价、证据登记与审计时读取。

不要为了“更完整”加载与当前行无关的参考。

## 输入策略

用户可以只给自然语言。内部归一化为语义对象，但不要强迫用户填写表格。以下是最常用的**核心字段**；交互、复杂运镜、Kling 动作控制、原地锁定等**扩展字段与完整清单见 `references/input-schema.md`**：

```yaml
mode: auto | actor_cut | narrative | environment
model: both | seedance2 | seedance2_5 | kling3_standard | kling3_omni | kling3_motion_control
duration:
characters:
relationship:
analysis_depth: auto | light | standard | deep
style_contract:
given_circumstances:
target_person:
want:
tactic:
turning_trigger:
display_policy: reveal | restrain | deny | redirect
intensity: L1_leak | L2_breach | L3_dysregulation
dialogue:
shot_constraints:
camera_intent:
ending:
```

按需从 `references/input-schema.md` 取用的扩展字段簇：交互与实体契约（`interaction_class / target_presence / target_visualization / render_mode / entity_contract / source_preflight` 等）、完整 Camera Unit（`viewer_relation / movement_driver / camera_subject / spatial_transform / subject_coupling / execution_source` 等）、Kling 动作与原地控制（`kling_workflow / motion_reference / gaze_behavior / root_motion` 等）。

只在缺失信息会改变表演或镜头策略时追问，例如：不知道刺激是什么，且“听到坏消息”与“看见证据”会产生不同动作；或不知道环境镜头应揭示入口还是异常细节。其他缺失项做最小合理推断，并在结果中用一行说明。

模型默认值：

- 用户未指定模型：同时输出 **Seedance 2.5** 与 Kling 3.0 两版（2.5 为当前默认 Seedance 版本；需要 2.0 时明确指定）。
- 用户指定模型：只输出该模型版本。
- Seedance 2.5：按 `adapters/seedance-2.5.md` 输出（最长 30s 直出）；编号绑定参考素材，叙事用 `镜头 N`、卡点用整数秒时间戳。Seedance 2.0：按 `adapters/seedance-2.md`（`镜头 N` 无时间标注）。情绪表演走 `references/longform-performance-pattern.md`。
- Kling 未指定 Standard/Omni：单人或简单单镜用 Standard；只有角色/声音/多参考连续性确有需要时才用 Omni。
- Standard/Omni 是模型选择，single shot/Custom Multi-Shot/Motion Control 是执行工作流；不要把两者混为一类。
- 运镜复杂度不单独触发 Omni；先按 `references/camera-direction.md` 选择 Prompt、UI Camera Movement、Start/End Frames、视频参考或 Custom Multi-Shot。

## 工作流

### 0. 复杂度分档（先做）

按「路由表（唯一路由）」判定档位并完成读取；分档只改流程负荷，**不改证据门禁与默认输出契约**。fast 档直接走 `target → WANT → tactic → 一次可见变化 → ending` ＋ 一个 Camera Unit；standard 档用 `analysis_depth` 控制分析深度；deep 档逐项过质量门。

### 1. 判断模式

优先看镜头的叙事责任，不按人数机械判断：

- 表演用于展示角色状态，剧情环境只是刺激或背景：`actor_cut`。
- 表演产生可追踪的剧情后果：`narrative`。
- 没有主要 performer，镜头用于建立空间、社会关系、规模、入口或伏笔：`environment`。
- 单演员也可以是剧情表演；双人画面也可以由一个演员拥有 Actor Cut 式反应。

### 2. 建立角色行动逻辑或环境责任

`actor_cut` 与 `narrative` 按 `references/acting-craft.md` 选择最低够用的分析深度，再确定：

```text
style contract
→ given circumstances
→ target person
→ WANT
→ optional obstacle / stakes / HIDE-CONFLICT
→ tactic
→ expected effect
→ turning trigger
```

`WANT` 是角色希望对象做出、停止或允许的变化；`tactic` 是角色为了影响对象而正在做什么。只有场景确有阻力、风险、克制、否认、改道或内在冲突时，才补对应字段。

同一需求至少在内部考虑两个真正不同的 tactic。差异必须是人物如何影响对象，而不是更换表情或强度词。先通过用户硬要求，再依据关系、角色专属性、风格、镜头可读性和模型可执行性选择；不要调用固定情绪脸或行动动作词典。

`environment` 不虚构 target、WANT 或演员情绪；按 `references/camera-direction.md` 确定空间中需要建立、揭示、连接或保留的唯一主要信息。

### 3. 设计 Camera Unit

所有模式都按 `references/camera-direction.md` 执行：

```text
lock requirements and source geometry
→ define camera responsibility and viewer relation
→ compare two genuinely different viewing strategies
→ choose motivated static or movement
→ start frame / trigger / one main move / stop / end frame
→ coordinate subject, screen direction and model budget
→ choose execution source
```

- 候选策略必须改变观众如何进入、跟随或离开场景，不能只替换同义运镜术语。
- 静止镜头是正式设计结果；没有信息、关系、规模、注意力或导演视点变化时，不强行移动。
- 每镜只有一个主要运动任务；辅助 pan/tilt 只用于维持构图，不承担第二个揭示。
- 航拍、俯拍、POV、手持和 oner 只说明视点、质感或结构，不能替代路径、触发和落幅。
- 演员动作复杂时压缩运镜；运镜承担主要揭示时压缩演员动作。
- 图生视频若需要大量首帧外未知空间，标记几何风险并简化、改用参考或保持实验状态。
- 内部 Camera Unit 不直接堆入 Prompt；只保留模型需要的起幅、主路径、人物关系、停止和落幅。

### 4. 编译交互可见性与动作可行性

当场景存在交互对象、接触、物体交换、镜头表面动作或实体硬排除时，按 `references/interaction-performance.md` 执行：

```text
interaction class
→ target visualization
→ entity ownership and source preflight
→ contact / support dependency
→ legibility without target
→ render mode
→ action signature
```

- 先判断身体局部和物体归属，不把主角色自己的另一只手机械判成外部实体。
- 硬排除请求必须通过首帧门禁；首帧不可检查或已含禁用实体时，不输出不可运行 Prompt。
- 单向信号可直接渲染；短暂互惠动作只能作为待验证的接触暗示；持续接触和物体交换缺少必要对象时改为邀请等待或判定冲突。
- 物体交换所需物体必须已经存在于首帧或作为明确输入素材绑定并获准保留；仅设置 `new_entity_policy: allow` 不能替代这一前提。
- 隐藏对象时，内部保留戏剧目标，但模型正文只写获准主体及其动作，不虚构对方已经回应、接触、靠近或完成交换。
- 按起点、路径、表面朝向、接触/支撑、停点、收势和易混淆动作建立最小动作签名；不要建立固定动作词典。

### 5. 评估 Kling 动作执行路径

仅在输出 Kling 时执行。先判断用户需要的是“近似生成”还是“精确复现”，再按 `references/kling-motion-control.md` 选择：

- 可串行描述的一条简单动作链：`standard_single`；
- 复杂性来自多个镜头任务，而不是单个连续身体动作：`custom_multi_shot`；
- 要求精确路径/次数/节奏，或复杂表情与转头、手部、身体运动需要高协调：`motion_control`。
- `root_motion: locked` 是本 skill 的内部需求标签，不是 Kling 官方字段。先按 `[K-I2V-01]`、`[K-PROMPT-01]`、`[K-PROMPT-02]` 修正纯文本的主体运动状态、动作方向和竞争动作；只有用户明确接受更换工作流时，才另给 Motion Control 方案。

若用户没有动作参考且 Motion Control 才能可靠满足要求，明确指出素材需求；不要把 Omni 当成精确动作驱动替代品。

### 6. 组装可裁剪 Beat Graph

角色模式先按戏剧行动组织变化，再由 `references/acting-core.md` 映射为模型可见节点：

```text
existing expectation / baseline
→ received trigger
→ tactic becomes observable
→ actual or absent feedback
→ persist / escalate / redirect / stop
→ relationship or task residue
```

允许：

- 即时定向或短暂处理；
- 省略克制、升级、释放；
- 从高潮中段切入；
- 在阈值处有意切断；
- 克制成功直接成为结局。
- 没有可定位反馈时，以等待、继续争取或主动结束收束，不伪造“终于得到回应”。
- 高潮来自行动风险、控制破口、策略改变或结果确认，不只来自动作与表情变大。
- 回落来自反馈或重新控制，不机械恢复开场中性状态。

`environment` 跳过角色 Beat Graph，改用空间基线 → Camera Unit 触发 → 环境信息变化 → 落幅。背景群众、车辆、水面或树木只保留一个主要环境运动层。

### 7. 分配表演与镜头预算

每个 beat 首轮只安排一个主要表演意图：

- 简单表演：一个主通道，最多一个可读辅助通道；
- 复杂动作：允许完成同一动作所必需的机械联动，但按 `references/kling-motion-control.md` 写成一个 Motion Unit；
- 头、手、表情、重心各自承担不同表达任务时，必须删减、串行化或路由到 Motion Control，不能借“同时”强行合并。

动作必须同时满足：可见、有限、有方向、能排序、由刺激触发、服务角色目标。优先使用 `消失、停止、释放、返回、撤回、开始后中止` 等状态变化，而不是身体部位清单。

镜头与演员共用执行预算：复杂人物动作配简单镜头关系；复杂空间揭示配单一主体动作。两者各自承担独立变化时，先删除、串行或拆镜，不能借“同时”强行合并。

### 8. 控制时长

- 4–6 秒：trigger → 一次可见 tactic → ending。
- 7–10 秒：baseline → trigger → tactic → 可定位反馈或明确等待 → 一次调整或 ending。
- 11–15 秒：可增加一次策略改道、失败恢复、短对白或听者反馈。
- 16–30 秒（仅 Seedance 2.5 单次直出；其他模型走多片输出）：完整情绪弧，4–5 镜；**写实情绪表演中带对白的 beat 每镜 ≥6 秒**（`[USER-SD25-01]`/`[USER-SD25-02]` 验证节奏；10s 塞 3 镜的 ~3.3s/镜已实测失败）。形态与技巧按 `references/longform-performance-pattern.md`。

环境镜头按同一预算只保留一个主要空间建立或揭示；15 秒微序列每镜必须增加不同信息。若单条 clip 内 beat 超出预算，先删减或串行次要 beat；但当整条内容超出目标模型**单次生成的时长上限**时，默认按情绪阶段切成多条可运行 prompt（`video1`/`video2`…）覆盖完整内容，**不以删内容为默认**（见 `references/longform-performance-pattern.md` §4.1）。不要承诺镜内精确到秒的微动作或相机关键帧。

### 9. 渲染模型版本

- Seedance：结构化分镜（`镜头 N`；2.0 不写时间标注、2.5 可用整数秒时间段），因果相对时序只在 Shot 块内部；保留 Camera Unit 的起幅、主运动和落幅；复杂路径优先使用视频参考。
- Kling：把 UI/API 配置与正文分开；Prompt 与独立 Camera Movement 控件不得冲突；Custom Multi-Shot 每镜一个戏剧和视觉任务并给逐镜时长。
- Kling Standard/Omni 的演员 Cut 情绪输出：正文使用带时间范围的分段框架。分段数量、边界与状态标题按本次表演动态生成；标题直接写 `【0–1.4s｜状态】`，不得在时间前添加“约”。正文同时声明时间范围仅作节奏参考，跨段动作必须连续，不得在边界停顿、重置或重新起势。Motion Control 不使用该框架驱动动作。

模型适配只改变表达包装与镜头执行来源，不改变角色行动、camera intent 或落幅责任。

### 10. 质量检查与定向护栏

按路由表的分档执行质量检查：所有档位执行核心程序（需求逐项核对、自足性与必写项、默认输出契约，见“默认输出”节）；deep 档与成片评价另按 `references/quality-gates.md` 逐项过 A–H 细则。护栏只针对当前已知或高概率失败，首轮保持少量、不冲突，并优先给正向替代：

```text
差：no random gestures
好：hands remain on the table; the right thumb tightens once and releases
```

新增或修改模型能力、失败归因和稳定修复规则前，执行证据门禁：

- 官方能力事实必须登记官方来源；
- 用户实测只在相同模型、工作流与约束范围内成立，不扩写成普遍因果；
- 尚未获得官方依据或用户生成结果的修复，只能作为“待验证实验版本”输出，不能写入稳定规则或宣称已修复；
- 证据状态与编号统一记录在 `references/evidence-ledger.md`。

用户提供成片或多个 Take 时，先按 `references/performance-review.md` 区分需求偏差、模型伪影、表演策略、镜头设计、镜头执行和呈现干扰，定位最先失效的 Beat 或 Camera Unit 节点。只修正该节点及其下游，再返回正常设计与模型渲染流程；不以评价报告替代改进。

## 默认输出

除非用户要求更短或更完整，按以下顺序输出：

1. `模式判断`：模式、必要假设、模型选择。
2. `交互处理`：仅在交互任务中输出 `直接动作 | 单边接触暗示（待验证） | 邀请并等待 | 需求冲突`。
3. `导演逻辑`：角色模式用一句话说明刺激、目标、策略和结束状态；环境模式说明要建立或揭示的空间信息。
4. `镜头设计`：用一至两行写 `起幅 → 运镜驱动 → 主运镜 → 落幅；执行方式`。选择静止时同样说明观看责任。
5. `Seedance Prompt`：仅在需要 Seedance 时输出，标题标明实际版本（`Seedance 2.5 Prompt` 或 `Seedance 2.0 Prompt`），按对应适配器渲染。
6. `Kling 3.0 配置` 与 `Kling 3.0 Prompt`：仅在需要 Kling 时输出；多镜逐镜列出。Motion Control 还要输出动作来源、Facial Element 参考计划和不与动作参考冲突的补充 Prompt；素材不足时同时给出缺口与可运行的 Standard 降级方案。
7. `成功标准`：三条可从成片直接观察的标准。角色模式分别覆盖核心行动/ending、Camera Unit 的执行或落幅、主体—镜头协调；环境模式覆盖镜头意图、路径/落幅和空间几何；交互任务优先覆盖实体许可、动作可读性及结束状态/镜头协调。不要让新增镜头验收挤掉用户的核心表演或交互要求。
8. `不确定性 / 调试`：只写最主要的一条，不承诺硬控制。

若交互任务触发 `source_preflight: block` 或 `render_mode: incompatible`，不要输出不可运行 Prompt；改为输出冲突、最低改动的素材/动作方案及继续生成所需条件。

Prompt 本体应可直接复制；镜头设计必须已经写入正文，不要求用户自行拼接。分析要短，不复述用户剧情或暴露完整 Camera Unit。

内容超出目标模型单次生成上限时，逐条输出 `video1 / video2 …` 的可运行 Prompt 及各自时长，每条重复身份契约、声明与上一条结束状态的承接；默认不删内容，只有用户明确要单条成片时才压缩。

**所有 Prompt 一律用结构化分镜格式，不限类型**（情绪表演、剧情、空镜/环境等都适用）：身份/主体契约 → 场景/总纲 → `Shot 01–N` 分段 → Performance Direction/持续约束 重述（验证格式的权威样本见 `templates/` 母版）。**不用连续 prose 段落**；单一不可切分的动作写成单个 `Shot`（N=1），而非回退 prose。Seedance 顶部先声明镜数/时长/画幅（官方 `[S20-FMT-01]`），Kling 演员 Cut 情绪用 `【0–t｜状态】` 时间分段。相对时序词（when / after a beat / only then）只在**单个 Shot 内部**描述 beat 时使用。

**输出格式规范**（`[USER-FORMAT-01]`，以已验证 fixture 的微格式为渲染基准）：

- Seedance 镜头标题用**裸标题行** `镜头 N`（英文 `Shot N`），**不带说明后缀**；每镜的唯一情绪任务写进该镜正文，不写进标题。
- **每句一行**：正文按验证模板逐句分行书写，不写多句连排的长段落。
- **对白块**：`对白：` 标签独占一行，引号内容在下一行；同一段对白的续句直接引号另起一行，**不重复标签**；delivery 说明用独立短句行放在对白前或后。不用“台词：”。
- **表演指导（L5）**：逐句重述头部的身份、场景、镜头与核心情感事实（变体 A），不写压缩综述段。
- Kling 的 `【0–t｜状态】` 分段框架不受此规范影响（状态名是该已验证框架的组成部分）。

**每条 Prompt 必须独立自足**（`[USER-PROMPT-01]`）：模型对上一段视频与整体剧情**没有记忆**；叙事承接、反打、“同一个夜晚 / 刚说完 / 承接上一段”等上下文只用于**内部设计，不写进 Prompt 正文**。需要连续性时用**显式可见状态**（首帧、姿态、泪光、位置、未说完的话）描述，不引用“上一段/承接”。**场景/氛围/光/可见生理信号，以及构图/视角/景别（如过肩、越肩前景、正面、POV、俯拍）都是每条 Prompt 的必写项**，**图生视频也不省略**——i2v 只是不重复首帧已提供的空间几何与未知空间，不等于删掉氛围、光、可见信号或构图。

**用户明确的硬要求（人物、构图/机位、景别、时长、台词、光、画外对象等）在任何 revision（含改为图生视频）中不得因内部推断而静默删改**；某项是否保留不确定时（如 i2v 首帧是否已含过肩前景），先向用户确认，不默认替换。**输出前逐项核对**：用户明确列出的每一项硬要求都要能在最终 Prompt 正文里找到对应描述——这一步在 prompt 阶段完成，不要等成片回看才发现缺失。

当输出 Kling Standard/Omni 演员 Cut 情绪 Prompt 时，分段框架属于 Prompt 本体，不额外输出一份连续 prose 版本。Motion Control 按专用输出契约执行。

若用户只要求成片评价，按 `references/performance-review.md` 输出简短的结论、问题归属、可观察证据和一项最高收益修正；没有成片时只能评价设计风险。用户要求修正版 Prompt 时，再使用上述默认输出契约。

## 示例（黄金样例）

一个快车道 actor_cut 的完整输入→输出,用于锚定产出形态。其他任务按各自默认输出契约调整。

**输入**：`Kling 3.0 Standard，8 秒，演员 Cut，单人面对镜头，无台词。久别重逢，情绪充分但不过度；人物始终原地，只允许面部、肩部和双臂动作。`

**输出**：

> **模式判断**：`actor_cut`（单人对镜、表演即内容）；模型 Kling 3.0 Standard 单镜；复杂度=快车道。假设中近景、稳定单镜。
>
> **导演逻辑**：角色对镜头前想象中的重逢对象，想让对方确认“我还在、可以靠近”；策略是压住冲击、用放开的肩臂发出邀请；结束停在敞开等待，不虚构对方回应。
>
> **镜头设计**：中近景固定机位建立对视 → 无运镜驱动（保护微表演）→ 全程 static、人物—镜头距离不变 → 落幅停在肩臂打开、目光留在镜头；执行方式：prompt（单镜）。
>
> **Kling 3.0 配置**：模型 Standard 3.0；模式 single shot；总时长 8s；`root_motion: locked`（内部需求标签，非官方字段）。
>
> **Kling 3.0 Prompt**：
>
> ```text
> 8 秒稳定单镜中近景，无台词。人物自始至终站定，双脚持续承重，人物与镜头的距离保持不变。时间范围仅作节奏参考，动作可自然提前或延后；所有变化连续衔接，不在分段边界停顿、重置或重新起势。
>
> 【0–1.3s｜静立辨认】
> 人物正面对镜，目光已落在镜头上，肩背安静，呼吸平稳。
>
> 【1.3–2.8s｜认出的冲击】
> 目光一次收紧，下颌微收，嘴角先抿后松；肩线一次轻抬又落下，情绪浮起但压住。
>
> 【2.8–5.7s｜放开邀请】
> 笑意漫开，眼里泛起水光但不落；双臂沿身体横向向左右缓缓打开到略宽于肩，掌心朝向镜头，肩胸随之舒展。
>
> 【5.7–8s｜敞开等待】
> 动作停在双臂打开、身体前敞；目光继续留在镜头上，一次轻微点头；姿态保持不收回。
>
> 单人；画面只有该角色；不迈步、不前倾、不靠近或远离镜头、不做全身返回；双手完成一次横向打开即停。
> ```
>
> **成功标准**：①读得出“辨认—压住—放开邀请—敞开等待”的递进，结尾停在敞开而非恢复中性；②全程固定中近景、人物与镜头距离不变、无推拉环绕；③人物原地无走近/退回，面部与肩臂动作互不打架。
>
> **不确定性/调试**：Standard 纯文本不保证零根位移；若出现走近/退回，先强化“站定、双脚承重、距离不变”并删除任何前后向措辞，而非叠加否定词。

该样例与已验证回归 `tests/fixtures/kling3-standard-stationary-reunion.verified.md` 同条件；改变模型、工作流、景别或主要动作方向时需重新验收。

## 禁止事项

- 不把悲伤、内疚、爱意等写成固定面部或身体指纹。
- 不建立固定的“行动动词—身体动作”词典。
- 不把 FACS、微表情、眨眼率或吞咽当成读心密码。
- 不用 `cinematic / realistic / deeply emotional` 替代具体动作。
- 不让所有角色同时表演；每个 beat 指定 reaction owner。
- 不建立“情绪—运镜”词典，不因独白、哭泣、高潮或浪漫场景自动推近、环绕或升降。禁的是**无场景理由的自动映射**；本场显式设计的、有动机的运镜—情绪耦合（如“情绪升高时缓慢靠近、沉默时静止”）是合法设计（`[USER-SD25-02]` 已验证），须写明动机。
- 不用 `cinematic / sweeping / Hollywood blockbuster / 8K / masterpiece` 代替起幅、驱动、路径、停止和落幅。
- 不复制本地 Cinematique 模板中的机型、镜头、胶片、色彩或导演标签，除非用户明确要求该视觉规格。
- 不把航拍、手持、POV、俯拍或 oner 当作完整运镜设计。
- 不让一个单镜同时承担多个独立运镜任务；辅助构图修正不能成为第二个揭示。
- 不把“没有生成对方”直接判为交互动作成功，也不把一次动作可读判为实体排除稳定。
- 不在对象不可见时虚构持续接触、承重、拉力、物体转移或对方已经回应。
- 不堆叠眉、眼、嘴、呼吸、肩、手、重心和镜头运动。
- 不默认峰值从第一帧开始，也不强迫所有场景先延迟再反应。
- 不承诺精确镜内秒点、相机关键帧、复杂路径、完美口型、负面提示词服从或模型绝对优劣。
- 不输出与目标平台不一致的伪官方字段。
