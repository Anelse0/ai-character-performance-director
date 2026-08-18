# 镜头导演与运镜引擎

## 目录

1. 职责与边界
2. 证据基础
3. 镜头语义接口
4. 镜头推导流程
5. Camera Unit
6. 术语分层
7. 三种模式的镜头责任
8. 人物与镜头协同
9. 模型执行过滤
10. 输出压缩与验收

## 1. 职责与边界

本 Reference 决定观众从哪里、以什么关系、在什么时刻看见什么，并把结果编译为可交给模型的镜头行为。它不替代表演策略、完整分镜、灯光设计或美术风格。

支持：

- 演员 Cut 的固定或运动镜头；
- 剧情行动中的跟随、揭示、转移注意与后果停留；
- 空镜、航拍、建立镜头和场景介绍；
- 单镜及 15 秒内微型多镜序列。

不支持：长场景 coverage、全片 shot list、完整轴线图或剪辑方案；这些需求应交给专门的分镜流程。

镜头设计的目标不是增加运动，而是建立以下因果：

```text
观众此刻需要看见什么
→ 为什么镜头保持或开始移动
→ 镜头如何与人物或空间建立关系
→ 运动改变了什么信息、距离、规模或注意力
→ 镜头最后把观看责任交给哪里
```

## 2. 证据基础

### [CAM-ASC-01] 人物与行动驱动镜头

- 类型：行业实践。
- 来源：[American Cinematographer — Echo: Freedom and Realism](https://theasc.com/article/echo-freedom-and-realism/)，访问：2026-08-13。
- 支持：Kira Kelly, ASC 说明会寻找让人物驱动镜头运动的方法，不因独白本身机械推进。
- 用法：默认先设计人物调度或场景变化，再判断镜头是否需要移动。

### [CAM-ASC-02] 镜头可以持有独立导演视点

- 类型：行业实践。
- 来源：[American Cinematographer — Children of Men: Humanity’s Last Hope](https://theasc.com/article/children-of-men-humanitys-last-hope/)，访问：2026-08-13。
- 支持：镜头可暂时脱离人物路径，留下观察后果或重新定义情境，成为有立场的观看者。
- 边界：独立移动必须回答为何不再跟随人物，以及观众因此看见了什么；不能把随机游移称为导演视点。

### [CAM-ASC-03] 功能、空间与银幕方向优先

- 类型：行业实践。
- 来源：[American Cinematographer — Sinister Sect: Spectre](https://theasc.com/article/sinister-sect-spectre/)，访问：2026-08-13。
- 支持：镜头运动应功能化而非装饰化；动作场面需严谨维护 screen direction，才能在快速剪辑中保持清晰。

### [CAM-ASC-04] 运动工具服从镜头任务

- 类型：行业实践。
- 来源：[American Cinematographer — Shot Craft: Tools for Camera Movement](https://theasc.com/article/shot-craft-camera-movement/)，访问：2026-08-13。
- 支持：镜头运动从剧本和导演意图开始，再选择适合运动性质与空间条件的实现方式；不同稳定系统产生不同运动质感。
- 边界：本 skill 描述视觉行为，不把真实片场器材名称伪装成 AI 模型控制字段。

### [CAM-LOCAL-01] 本地 Cinematique 术语资料

- 类型：用户提供的本地创意参考。
- 来源：`/Users/leo/Desktop/Research/cinematiqueSeo-CPnkbnGL.js`，检查：2026-08-13。
- 内容：150 项技法，含 41 项 Camera Work；提供术语、定义、案例与 Prompt 模板。
- 允许：辅助识别景别、角度、视点、运动、稳定质感、焦点和镜头结构术语。
- 禁止：直接复制模板中的机型、镜头、胶片、色彩、8K、导演标签或固定 mood；不得作为 Kling、Seedance 或其他模型能力证据。

### [USER-CAMERA-01] 镜头导演引擎设计边界

- 类型：用户批准的 skill 工作流。
- 批准日期：2026-08-13。
- 要求：覆盖角色与环境镜头；主动判断运镜但允许有理由的静止；支持单镜与 15 秒内微序列；使用 Camera Unit、模型执行过滤和可观察验收。
- 边界：这是生成决策规则，不构成模型稳定执行复杂镜头的保证。

## 3. 镜头语义接口

用户无需填写。内部按最低够用深度推导：

```yaml
camera_intent:
viewer_relation:
movement_driver:
camera_subject:

camera_unit:
  start_frame:
  trigger:
  spatial_transform: static | translate | rotate | optical | focus
  trajectory:
  subject_coupling: follow | lead | parallel | counter | reveal | leave_behind | independent
  speed_profile:
  stabilization_texture:
  framing_correction:
  stop_condition:
  end_frame:

screen_direction:
execution_source: prompt | ui_control | start_end_frames | video_reference | custom_multishot
execution_status: supported | experimental
```

字段含义：

- `camera_intent`：镜头要改变观众的注意、信息、关系、规模感或节奏中的哪一项。
- `viewer_relation`：观众是平等观察、陪伴、追随、主观代入、全知观察，还是被有意留在后果上。
- `movement_driver`：人物调度、信息揭示、注意转移、空间规模、节奏转折，或明确的导演视点；可以是 `none`。
- `camera_subject`：运动和构图持续围绕的人、物、空间关系或揭示目标。
- `start_frame / end_frame`：运动前后可直接描述的构图，不只是“开始/结束”。
- `trigger / stop_condition`：镜头开始和停止的可定位事件。
- `spatial_transform / trajectory`：相机如何改变位置、朝向、焦距或焦点。
- `subject_coupling`：相机与主体路径的关系，不是器材名称。
- `speed_profile`：匀速、缓起、加速、减速或短促切换；只保留场景必要信息。
- `stabilization_texture`：锁定、平滑漂移、有人体呼吸感的手持等视觉性质。
- `framing_correction`：为维持主体构图所需的次要修正，不能承担第二个戏剧任务。

## 4. 镜头推导流程

### 4.1 锁定输入与首帧

先锁定用户明确要求、画幅、景别、时长、人物走位、台词、参考素材及起始构图。图生视频还要检查：目标运镜是否要求首帧以外的大量未知空间、背面或遮挡后内容。

若路径显著扩写首帧外空间，依据 `[K-I2V-02]` 与 `[USER-CAMERA-01]` 标记几何风险；简化路径、改用参考素材或明确为实验版本，不宣称一定变形。

### 4.2 确定镜头责任

回答一个主问题：这一镜结束时，观众相较开头多知道、少知道、靠近、疏远或重新关注了什么？

若答案只是“更电影感”，镜头责任不成立。保留静止或返回场景逻辑。

### 4.3 比较观看策略

内部至少考虑两条真正不同的观看策略，例如：

- 陪人物行动，而不是把人物留在画外；
- 放弃跟随人物，停在行动后果上；
- 从整体进入局部，而不是从局部揭示整体；
- 保持客观距离，而不是进入角色主观视点。

差异必须改变观众如何理解场景，不能只是替换同义运镜术语。先通过用户硬要求，再按叙事清晰、表演可读、风格、连续性和模型可执行性选择。

### 4.4 判断静止或移动

仅在至少满足一项时移动：

- 需要跟随或预领一个有方向的主体行动；
- 需要揭示此前不可见但剧情相关的信息或规模；
- 需要把注意力从一个明确对象转移到另一个对象；
- 需要让观众关系从观察转为参与，或反向退出；
- 需要在行动后留在不同主体、空间或后果上；
- 风格契约明确需要带有物理存在感的观察者视点。

其他情况可选择静止。静止镜头是正式设计结果，也要写明它保护微表演、维持客观性、积累等待、保持空间清晰或拒绝替角色做判断中的哪一项。

## 5. Camera Unit

每镜只编译一个 Camera Unit：

```text
起始构图
→ 可定位触发
→ 一个主要运镜
→ 必要构图修正
→ 明确停止条件
→ 有叙事意义的结束构图
```

规则：

1. 一个镜头只有一个主要运动任务。
2. 辅助 pan/tilt 只用于保持主体构图，不能同时承担新揭示。
3. 起幅和落幅必须可观察；只有形容词变化不算构图变化。
4. 镜头开始与停止要由事件、动作位置或揭示完成触发，不要求模型命中精确帧点。
5. 结束构图必须能保持到切点，并与下一镜需要的 screen direction、eyeline 或空间信息兼容。
6. 固定机位使用 `spatial_transform: static`，仍要定义起幅、持续观看责任和落幅状态。

“大片质感”从以下组合产生，而不是从器材词产生：

- 清楚的空间关系与运动方向；
- 前、中、后景提供的层次和视差；
- 有目的的规模变化或信息揭示；
- 运动的缓起、持续与落稳；
- 镜头运动、人物调度和剪辑落点之间的配合；
- 一段序列中静与动、近与远、主观与客观的对比。

不要求每镜同时具备这些元素，只选择服务当前镜头责任的最小组合。

## 6. 术语分层

不要沿用本地资料把所有术语放在同一层。按以下维度拆分：

| 维度 | 示例 | 作用 |
|---|---|---|
| 景别 | wide、medium、close-up | 决定信息和表演可读范围 |
| 角度/高度 | eye-level、high、low、overhead | 决定空间与观看关系 |
| 视点 | objective、POV、head-on | 决定观众是否进入主体经验 |
| 空间位移 | push、pull、track、rise、descend、orbit | 改变相机位置和视差 |
| 轴上旋转 | pan、tilt、roll | 改变观看方向，不等同于平移 |
| 光学/焦点 | zoom、rack focus | 改变画面关系但不等同于相机位移 |
| 稳定质感 | locked、dolly-smooth、floating、handheld | 决定运动的身体感 |
| 镜头结构 | establishing、master、oner、insert | 决定镜头在序列中的责任 |

航拍、俯拍、手持、POV 和 oner 都不能单独替代 `trajectory`。例如“垂直俯拍航拍”只说明高度与角度，仍需另行决定静止、沿轴平移、上升、下降或旋转。

## 7. 三种模式的镜头责任

### Actor Cut

- 首要责任是保护表演 onset、台词归属和余波可读性。
- 默认主动判断静止；使用运动时只服务一次策略变化、关系靠近/退出或信息确认。
- 不因角色开始说话、哭泣或进入高潮自动推近。禁的是无场景理由的自动映射；**本场显式设计、写明动机的运镜—情绪耦合是合法的**（如“情绪升高时缓慢靠近、沉默时静止”，`[USER-SD25-02]` 已验证），仍须服从每镜一个主运镜。
- 特写或中近景已有复杂头、手、身体动作时，优先静止或极简运动。

### Narrative

- 先确定人物调度、事件、reaction owner 和剧情后果，再选择跟随、预领、揭示或留在后果。
- 多镜头每镜只有一个视觉或剧情任务；camera residue 与表演 residue 一起传递。
- 动作场面明确人物和相机 screen direction；快速剪辑不能依靠随机换角度制造能量。

### Environment

- 没有主要 performer 时，以空间、社会关系、时间、规模、入口或伏笔作为 `camera_subject`。
- 先说明建立什么环境信息，再决定是整体观察、沿空间路径进入、从局部揭示全貌或停在异常细节。
- 环境内已有群众、车辆、水面或树木活动时，只选一个主要环境运动层，不逐个调度所有背景元素。
- 航拍必须分别定义角度、高度关系、主路径和落幅；不使用 `sweeping cinematic aerial` 代替设计。

## 8. 人物与镜头协同

演员动作与镜头共用执行预算：

- 演员有复杂转身、跑跳、交互或多步动作：镜头保持固定关系或只完成简单跟随。
- 镜头承担规模揭示、明显环绕或长距离路径：主体动作保持单一、方向清楚。
- 跟随：明确镜头位于主体前、后、侧面或斜侧，并保持何种距离。
- 预领：镜头先到达主体将进入的位置，必须有明确揭示或期待目的。
- counter move：人物和镜头相反方向运动时，只有空间逻辑清楚且模型预算允许才保留。
- leave-behind：人物离开后，明确镜头留下观看的后果，不能无目的失去主体。

若人物路径和镜头路径需要各自承担独立变化，先删减或串行；不能用“同时”掩盖竞争任务。

## 9. 模型执行过滤

先完成模型无关的 Camera Unit，再由适配器选择执行来源：

- `prompt`：简单单轴或单一跟随关系；
- `ui_control`：当前入口确有独立 Camera Movement 控件；
- `start_end_frames`：用户能提供两端画面，只锚定端点，不宣称中间路径精确；
- `video_reference`：需要复现复杂路径、节奏或多轴协调；
- `custom_multishot`：复杂性来自多个镜头任务，而不是单镜内多轴运动。

若执行来源无法满足 Camera Unit：

1. 保留镜头意图；
2. 简化运动路径或拆成多个视觉任务；
3. 必要时要求参考素材；
4. 仍不稳定时标记 `experimental`，不把长 Prompt 当作硬控制。

具体平台能力与边界见 `adapters/kling-3.md`、`adapters/seedance-2.md` 和 `references/evidence-ledger.md`。

## 10. 输出压缩与验收

内部字段不直接堆入最终 Prompt。默认只额外输出一至两行：

```text
镜头设计：[起幅] → 因[驱动]开始[主运镜] → [落幅]；执行方式：[来源]。
```

Prompt 正文保留：

- 起始构图和 camera subject；
- 一个主运镜及其方向、速度或稳定性质；
- 与人物动作的关系；
- 停止条件和结束构图；
- 当前模型真正需要的一条风险护栏。

成片至少分别验收：

1. `camera_intent`：镜头是否改变了预定的信息、关系、规模或注意力；
2. `camera_execution`：路径、方向、起落幅和停止是否可读；
3. `subject_camera_coordination`：主体没有因镜头竞争而失去表演、身份、空间或动作清晰度。

不得用“画面更电影”“更有大片感”替代可观察标准。
