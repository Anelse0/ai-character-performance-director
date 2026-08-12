# Kling 复杂动作与 Motion Control

## 内容索引

- 使用边界与复杂度对象
- 工作流路由
- Motion Unit 与并发处理
- 对镜眼神协调
- 原地表演与根位移锁定
- 复杂情绪参考计划与证据边界

## 使用边界

本文件用于选择 Kling 的动作执行工作流。先区分：

- `Standard / Omni`：模型与参考能力选择；
- `single shot / Custom Multi-Shot / Motion Control`：动作和镜头的执行方式。

Omni 可增强多参考、人物和声音连续性，但不等于精确动作驱动。Motion Control 的动作来自上传的动作视频或平台 Motion Library，不是仅靠正文 Prompt 生成。

Motion Control 只解决动作来源与路径控制，不是实体排除工具。涉及隐藏对象、额外手、道具、影子或倒影时，仍须先执行 `references/interaction-performance.md` 的实体契约与首帧门禁；动作参考中已有的对象也不会因为正文禁用而被视为已清除。

## 复杂度对象

只提取会改变工作流的字段：

```yaml
motion_scope: localized | upper_body | full_body
motion_precision: approximate | repeatable | exact
motion_concurrency: 独立动作任务的数量与是否同时发生
direction_changes: 主要方向变化次数
head_turn: none | small | profile_or_larger
face_occlusion: none | brief | sustained
identity_sensitivity: normal | high
motion_reference: none | uploaded_video | motion_library
facial_element: none | images | video
spatial_lock: none | soft | hard
root_motion: allowed | bounded | locked
spatial_control: prompt_only | motion_control
```

机械上不可分割的联动不算多个独立任务。例如一次轻跳所需的屈膝、离地与落地属于一个动作单元；“跳跃时招手、挑眉并嘟嘴”则包含多个竞争任务。

## 工作流路由

### Standard single shot

满足以下条件时优先：

- 用户接受动作近似生成；
- 主要动作能写成一条清楚的串行链；
- 不依赖精确轨迹、逐帧节奏或多个身体区域的同步；
- 身份不需要在明显转头、遮脸或高速动作中严格保持。
- 硬空间要求若仍使用 Standard，用户接受它是需要成片验证的文本方案，而不是已保证的精确复现。

若动作过载，先删除装饰性动作，再把剩余动作串行化。不要用更多时间段掩盖并发冲突。

### Custom Multi-Shot

仅当复杂性来自多个镜头的叙事任务时使用，例如 setup、action、reaction 需要不同机位。它不用于把一个本应连续完成的演员动作切碎，也不提供镜内关节级控制。

### Motion Control

出现以下任一情况时优先建议：

- 用户要求精确复现动作路径、次数、节奏或同步关系；
- 复杂表情变化与明显转头同时发生，并要求身份稳定；
- 手部靠近或遮挡面部，同时需要保持表情连续；
- 头、手、重心或全身动作必须按指定关系协调；
- 用户已经提供动作视频，或愿意使用 Motion Library。
- 人物零位移是硬验收条件，且已有动作参考能原地完成所需动作；或 Standard 已被用户实测出现位移，用户愿意补充动作参考。

若无动作参考，不伪装成 Motion Control 已可运行：输出缺失素材及可降级的 Standard 方案。以上路由阈值是本 skill 的可靠性策略，不是 Kling 官方字段。

## Motion Unit

复杂动作不只写动作名称。按可见需要从下列字段中选择，形成一条连续的机械链：

```text
goal_and_receiver
→ starting_pose_and_support
→ preparation
→ primary_path_and_direction
→ speed_rhythm_and_amplitude
→ contact_or_weight_transfer
→ landing_or_follow_through
→ camera_relationship
→ stable_end_state
```

不要机械填满所有字段；只保留观众必须看见、模型必须区分的部分。

### 跳跃与蹦跳

至少写清准备、主要动作和落地反应：

```text
膝盖轻微屈曲蓄力
→ 身体低幅度垂直离地
→ 双脚回到原位置
→ 膝盖柔和缓冲并重新站稳
```

补充次数、方向和幅度，但不伪造关节角度或逐帧轨迹。中近景看不清脚部时，把重点放在膝部屈伸、身体垂直位移和落稳；若脚步接触是成败关键，应改用能看到全身和地面的景别。

### 手势

写清：哪只手、从哪里开始、沿什么路径、朝向谁、速度与幅度、何时停止或收回。情绪力度必须附着在具体速度、幅度或收势上，不能只写“情绪化地挥手”。

### 动作与表情

表情必须服务同一行动意图。允许一个主要动作带一个低负荷表情伴随；若表情本身还包含独立的出现、峰值和释放，应放在动作落稳后，或改走 Motion Control。

### 并发冲突处理

遇到“转头＋挑眉＋招手＋蹦跳＋嘟嘴”时：

- Standard 降级：保留最能获得关注的一套动作，例如“单手招手＋两次低幅蹦跳”，删除挑眉和独立探头，落稳后再短暂嘟嘴；
- Motion Control：动作参考可以保留完整组合，但仍应以适中速度、连续动作和清楚收势为目标。

不要通过增加时间分段把同一瞬间的多任务冲突隐藏起来。

## 对镜眼神协调

对镜表演使用 `establish → naturally adjust → reacquire`，不要在运动阶段反复写“始终直视前方”：

1. `establish`：静止或起势前，目光柔和地落在镜头目标区域，建立清楚的对视感；
2. `naturally_adjust`：转头、招手、起跳或落地过程中，注意力仍给镜头前的人，但眼神允许在镜头区域内自然补偿，不要求眼珠固定在眼眶中央；
3. `reacquire`：头部回正或身体落稳后，双眼方向协调地重新对上镜头，再进行需要被清楚读取的嘟嘴、等待或台词。

Prompt 优先写正向状态：

```text
他的注意力始终给镜头前的人；静止时建立柔和对视，运动时眼神在镜头区域内自然调整，落稳后重新清楚地对上镜头。
```

仅在该问题已出现时补充：双眼方向保持协调、目光柔和，不出现僵硬瞪视或眼神无目标漂移。不要把“眼珠全程固定”“瞳孔始终居中”当成对镜要求。

这套眼神阶段是本 skill 的表演与生成稳定性策略，不是 Kling 官方参数。

## 原地表演与根位移锁定

`spatial_lock` 与 `root_motion` 是本 skill 的需求标签，不是 Kling 官方字段。

### 已验证边界

- `[USER-K3-01]`：在用户本轮的 Kling 3.0 Standard、8 秒、单人中近景测试中，上一版 Prompt 虽要求人物原地，结果仍出现向前走动后退回。该证据只证明这一次配置与措辞组合失败，不证明“前倾”“迎接”或其他单个词是唯一原因。
- `[USER-K3-02]`：同一类 Kling 3.0 Standard、8 秒、单人中近景测试中，改为先定义站定/持续承重/人物—镜头距离不变，只保留肩臂横向局部动作，并删除前后向路径及全身返回任务后，用户确认测试可行。该组合可作为匹配条件下的已验证修复。
- `[K-MC-01]`：Kling 官方说明 Motion Control 可从上传视频或 Motion Library 为单个角色分配动作，并控制动作与表情。
- `[K-MC-02]`：官方说明人物动作、表情及部分朝向/机位行为会跟随动作参考；生成长度与上传参考长度一致或以有效连续动作段为准。
- `[K-MC-03]`：官方建议动作参考使用单镜连续画面、避免剪切和机位运动，采用稳定的适中速度并尽量减少位移。

### 稳定路由

优先解决纯 Prompt 本身：

1. 用一句简单主体运动状态先定义“人物站定、足底持续承重、人物与镜头距离不变”；
2. 后续只描述允许发生的局部动作，并给出可见方向；原地表演优先使用左右、上下或关节局部路径，不再混入朝向镜头的前后路径；
3. 结尾从当前局部动作自然收势，不新增“退回/回到原位”的全身返回任务；
4. 减少竞争动作与同义否定，保持每个 beat 一个主要任务。

这套改写分别对应官方的“主体＋运动状态”、姿态/方向/接触/镜头关系和减少竞争动作指南 `[K-I2V-01]`、`[K-PROMPT-01]`、`[K-PROMPT-02]`。`[USER-K3-01]` 记录失败组合，`[USER-K3-02]` 已验证上述改写在匹配条件下可行；模型、工作流、景别或动作方向改变时重新验收。

只有用户明确接受更换工作流时，才另给 Motion Control；要求动作参考本身可见地原地完成目标表演，并遵守 `[K-MC-01]` 至 `[K-MC-03]`。

若用户没有动作参考、且仍要求纯 Prompt Standard：

1. 明确标为“待验证实验版本”；
2. 仅依据官方动作 Prompt 指南，把动作写成可见的姿态、方向、速度、接触/支撑和镜头关系，并减少竞争动作；
3. 不把任何尚未实测的锚点、否定词组合或替代动作写成稳定修复规则；
4. 等用户回传相同模型与配置下的生成结果后，再按 `references/evidence-ledger.md` 晋升、保留或否决该候选。

官方依据见 `[K-PROMPT-01]`、`[K-PROMPT-02]`；实验版本的效力必须由后续成片验证。

## 复杂情绪参考计划

Motion Control 的动作源与身份/表情参考承担不同职责：

- 动作视频或 Motion Library：提供动作、节奏和表情过程；
- 角色图：提供起始人物外观与画面；
- Facial Element：补充脸部身份、角度和目标表情的一致性。

根据目标动作准备最小充分参考：

| 目标 | Facial Element 建议 |
|---|---|
| 正面轻微表情变化 | 清晰中性正脸＋目标表情正脸 |
| 明显向左/右转头 | 清晰正脸＋对应方向侧脸 |
| 转头同时发生情绪变化 | 正脸＋涉及的目标表情＋对应方向侧脸 |
| 复杂连续表情且身份要求高 | 优先上传包含所需角度与表情的脸部视频 |

参考内容应与预期结果匹配；不要上传与目标角度、表情明显冲突的素材。Facial Element 只提供脸部信息，不负责锁定服装、发型、妆容或道具。

使用 Kling VIDEO 3.0 Motion Control 的 Facial Element Binding 时，遵守当前入口的 orientation 限制；官方指南说明 Element Binding 只在人物朝向匹配动作视频时支持。复杂动作参考优先保持单人、连续可见、适中速度，并让角色图与动作参考的半身/全身范围相匹配。

## 官方事实与设计推断

官方已说明：Motion Control 可从上传视频或 Motion Library 提取单个角色的动作与表情；Facial Element Binding 可增强复杂、多角度、长动作中的脸部一致性。官方也建议复杂表情和身份准确度要求较高时使用更连续的视频脸部参考。

本文件的复杂度字段、触发阈值与降级规则属于本 skill 的工程化推断。不要把它们称为 Kling 官方评分系统。

官方来源：

- https://kling.ai/quickstart/motion-control-user-guide
- https://kling.ai/blog/kling-ai-motion-prompts-guide
- https://kling.ai/quickstart/klingai-video-3-model-user-guide
