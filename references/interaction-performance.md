# 角色交互表演与实体可见性

## 目录

1. [职责与证据边界](#1-职责与证据边界)
2. [交互语义对象](#2-交互语义对象)
3. [可见实体契约](#3-可见实体契约)
4. [首帧门禁](#4-首帧门禁)
5. [交互类型路由](#5-交互类型路由)
6. [动作识别度编译](#6-动作识别度编译)
7. [隐藏对象编译](#7-隐藏对象编译)
8. [物理依赖与冲突处理](#8-物理依赖与冲突处理)
9. [击掌验收 Case](#9-击掌验收-case)
10. [输出与验证](#10-输出与验证)

## 1. 职责与证据边界

本 Reference 负责把“角色与谁互动”分成三项独立问题：

```text
戏剧对象是否存在
→ 对象是否获准出现在画面
→ 隐藏对象后，角色动作是否仍可读且符合物理逻辑
```

不要把“没有生成对方”直接判定为交互动作成功，也不要把动作可读误当成实体排除稳定。两项必须分别验收。

Kling 官方资料 `[K-I2V-01]`、`[K-I2V-02]`、`[K-PROMPT-01]`、`[K-PROMPT-02]` 支持使用简单的主体运动描述，并明确可见姿态、方向、接触/支撑、镜头关系与收势；官方没有保证隐藏交互对象后动作仍能稳定成立。交互分类、实体契约与降级规则是用户批准的 Skill 工作规则 `[USER-INTERACTION-01]`。

## 2. 交互语义对象

从自然语言内部推导：

```yaml
interaction_class:
  unilateral_signal
  | brief_reciprocal_contact
  | sustained_contact
  | object_transfer
  | offscreen_audio
  | offscreen_physical
  | spatial_invitation
  | lens_interaction

target_presence: visible | offscreen_audio | implied
target_visualization: allowed | forbidden
reciprocity: none | brief | sustained
contact_requirement: none | implied | required
external_support: none | person | object
legibility_without_target: high | medium | low
render_mode:
  direct_action
  | implied_contact_experimental
  | invite_and_wait
  | visible_interaction
  | incompatible
```

这些字段不替代 `target_person / WANT / tactic`：前者决定如何安全渲染，后者决定人物为什么互动。

不要根据动作名称直接套用身体答案。分类只决定需要检查的物理依赖、可见性和证据级别。

## 3. 可见实体契约

建立所有权优先的画面许可：

```yaml
entity_contract:
  allowed_owners: [primary_character]
  forbidden_owners: [interaction_target, unknown]
  allowed_existing_props: []
  new_entity_policy: allow | forbid
  visible_body_scope: preserve_source | user_defined
  reflection_policy: preserve | forbid_new
  shadow_policy: preserve | forbid_new
  source_preflight: pass | block
```

规则：

- 先判断身体局部属于谁，再判断是否获准出现。主角色自己的非动作手不等于“他人的手”。
- 只有用户明确要求“画面只显示一只手/某个身体局部”时，才限制 `visible_body_scope`。
- `new_entity_policy: forbid` 表示不新增人物、身体局部或道具，不表示仅凭 Prompt 可以删除首帧已有内容。
- `new_entity_policy: allow` 只在用户明确许可新增画面实体时使用；它不证明模型会稳定生成该实体，也不能替代物体交换所需物体的首帧存在或输入素材绑定。
- `allowed_existing_props` 只登记实际首帧可见或作为输入素材明确绑定、且用户允许保留的物体；不把 Prompt 计划生成的物体提前记为 existing。
- 影子与倒影按所有权处理；禁止新增不明归属的影子或倒影，不把主角色首帧已有的自然影子机械判为另一人物。
- Prompt 正文优先正向声明唯一获准主体和保持不变的既有场景，不反复列举被禁止实体。

## 4. 首帧门禁

硬排除请求必须先检查实际输入图：

1. 输入图可检查且不存在禁用实体：`source_preflight: pass`。
2. 输入图存在用户明确禁用的人物、身体局部或道具：`source_preflight: block`。
3. 输入图不可访问，且硬排除是否通过会改变可运行性：视为 `block`，先请求一张可检查首帧或一次明确确认。

`block` 时不输出视频 Prompt。只输出：冲突位置、需要裁切/清除/重做的内容、通过门禁后将继续的动作方案。

不能把首帧门禁写成平台保证。它防止输入与硬要求直接矛盾，不保证模型后续绝不生成新实体。

## 5. 交互类型路由

| 类型 | 典型责任 | 对象禁止具象化时的默认路由 |
|---|---|---|
| `unilateral_signal` | 招手、召唤、制止、指方向、飞吻、比心 | `direct_action` |
| `brief_reciprocal_contact` | 击掌、碰拳、短促轻碰 | `implied_contact_experimental` |
| `sustained_contact` | 握手、拥抱、牵手、搀扶、拉人 | `invite_and_wait`；不能保持物理成立时 `incompatible` |
| `object_transfer` | 递杯、接手机、收礼物、喂食 | 必要物体已获准且存在才执行，否则 `incompatible` |
| `offscreen_audio` | 被呼唤、听见警告、回答问题 | `direct_action`；使用可定位声音刺激，目标保持画外 |
| `offscreen_physical` | 被拍肩、被拉住、被触碰 | 硬排除对象时默认 `incompatible`；独立声音线索足以支持短暂暗示时才可用 `implied_contact_experimental` |
| `spatial_invitation` | 让座、示意靠近、示意进入 | `invite_and_wait`，不虚构对方已到达 |
| `lens_interaction` | 敲、擦、遮镜头 | 自有身体范围获准时使用 `direct_action`，同时标记高遮挡和手部畸变风险；否则 `incompatible` |

上述例子解释类别，不构成可复用动作库。遇到未列动作，按互惠程度、接触要求、外部支撑和隐藏后的可读性分类。

## 6. 动作识别度编译

对最终选择的 tactic 推导最小动作签名：

```yaml
active_owner:
starting_zone:
primary_path:
surface_orientation:
receiver_direction:
support_or_contact_plane:
speed_and_amplitude:
stop_condition:
follow_through:
camera_readability:
confusable_actions:
```

逐项提问：

1. 哪个轮廓、表面或方向使动作可被观众认出？
2. 哪条路径可能把它误读成另一动作？
3. 对象隐藏后，动作是否仍符合支撑、接触、重量与惯性？
4. 停点和收势表达邀请、等待、暗示完成还是主动结束？
5. 当前景别能否看清决定动作身份的信息？
6. 这些信息能否压缩成一个主 Motion Unit？

只把当前动作必需的字段交给 Prompt。若需要多个身体区域分别承担独立意义，先删减或串行，再考虑动作控制工作流。

## 7. 隐藏对象编译

当 `target_visualization: forbidden`：

- 内部保留完整戏剧对象、WANT 与交互名称；模型正文只渲染获准主体及其动作。
- 不写不存在的对方已经回应、靠近、接触、接住或完成交换。
- 无可定位反馈时，用角色自定时的停顿、继续争取、收势或等待结束。
- 只保留一条正向画面契约，例如“主角色保持为画面唯一表演主体，既有背景维持不变”。
- 不用多条“禁止其他人、禁止其他手、禁止物体”替代动作设计；纯文本实体排除仍是待生成验证的目标，不是保证。
- 可选声音只承担可定位刺激或接触暗示；不承诺声音与动作精确同步，也不借声音虚构可见对象。

## 8. 物理依赖与冲突处理

按以下顺序决定能否完成：

```text
是否需要对方或物体持续提供支撑/重量/拉力
→ 是否能在隐藏对象后保持物理合理
→ 是否仍能让观众识别动作
→ 直接动作 / 实验性暗示 / 邀请等待 / 冲突阻断
```

- 无外部支撑即可成立的交流信号可以直接渲染。
- 短暂互惠动作只有在角色一侧动作仍可读时才进入 `implied_contact_experimental`；默认称为“接触暗示”，不声称真实完成。
- 持续接触不能用空气中的重复摆动伪造；改成发起邀请并等待，或判定不兼容。
- 物体交换必须确认物体在首帧存在或作为明确输入素材绑定、归属明确且允许保留；`new_entity_policy: allow` 本身不能满足该前提。否则不生成“接住重量、握住新物体”等结果。
- Motion Control 可以改善角色动作路径，但不能作为实体排除方案，也不能消除动作参考里已有的对象或位移。

## 9. 击掌验收 Case

击掌只作为回归 Case，不作为通用动作模板：

```yaml
interaction_class: brief_reciprocal_contact
target_visualization: forbidden
contact_requirement: implied
legibility_without_target: medium
render_mode: implied_contact_experimental
```

为避免已出现的遮光/敬礼误读，动作签名必须表达：

- 动作手从身体同侧起势，不横跨胸前或扫过额头；
- 前臂向上展开，掌面竖直、手指朝上；
- 完整掌面朝向镜头，在肩部高度短暂停留；
- 沿镜头轴短距离前送一次，紧接一次轻微回弹；
- 从当前回弹自然收势，不追加第二次接触；
- 关键掌面在当前景别清楚可见。

最终成片仍须分别验收：没有外部人物、身体局部或新增物体；动作没有被读成挥手、敬礼、遮光、推掌或掌心向下悬停；观众能读出击掌邀请与一次接触暗示。纯 Prompt 方案在三次同条件生成全部通过前保持 `experimental`。

## 10. 输出与验证

交互任务在模式判断后增加一行：

```text
交互处理：直接动作 | 单边接触暗示（待验证） | 邀请并等待 | 需求冲突
```

- `source_preflight: block` 或 `render_mode: incompatible` 时，不输出不可运行 Prompt；输出冲突与最低改动方案。
- `implied_contact_experimental` 必须在不确定性中明确待成片验证。
- 成功标准至少分别包含一项实体许可、一项动作可读性和一项结束状态。
- 单次通过只记录该 Take；至少三次同模型、工作流、首帧、时长和 Prompt 的生成全部通过，才允许登记为限定条件下的稳定用户验证。
