---@meta

---См. разницу между `require` [тут](https://github.com/instead-hub/instead/blob/master/doc/modules3-ru.md#игровой-мир)
---@param path string
function include(path) end

---@alias RoomId string

---@class Player: Obj
---@field room (RoomId | Room) Стартовая комната игрока.
Player = {}

---Переместить игрока в указанную комнату.
---@param room (RoomId | Room)
function Player:walk(room) end

---@param p Player
function player(p) end

---@class Game
game = {}
---@type string
game.act = nil
---@type string
game.inv = nil
---@type string
game.use = nil
---@type Player
game.player = nil

---добавление в инвентарь предмета
---@param w (Obj | ObjId)
function take(w) end

--- Инициализацию игры следует описывать в функции `init`, которая вызывается движком в самом начале. В этой функции удобно инициализировать состояние игрока на начало игры, или какие-то другие действия, нужные для первоначальной настройки мира игры. Впрочем, функция `init` может быть и не нужна.
function init() end

---@alias ObjId string Идентификатор объекта.

---@class ObjArgs
---@field nam ObjId Идентификатор объекта.
---@field disp (string | false) Название объекта, когда он находится в инвентаре. Чтобы скрыть предмет в инвентаре, нужно присвоить значение `false`.
---@field dsc (string | fun(obj: Obj): (string | boolean | nil)) Описание объекта. Оно будет выведено в динамической части сцены, при наличии объекта в сцене. Фигурными скобками отображается фрагмент текста, который будет являться ссылкой в окне INSTEAD. Если объектов в сцене много, то все описания выводятся одно за другим, через пробел.
---@field tak (string | fun(obj: Obj): (string | boolean | nil)) Описание действия, когда игрок кликает на этот объект, когда он лежит в комна
---@field act (string | fun(obj: Obj): string?) Обработчик события, который вызывается при действии пользователя (действие на объект сцены, обычно – клик мышкой по ссылке). Его основная задача – вывод (возвращение) строки текста, которая станет частью событий сцены, и изменение состояния игрового мира.
---@field ini fun(obj: Obj) Запускается при инициализации.
---@field inv (string | fun(this): boolean?) Событие, которое вызывается, когда игрок использует этот же предмет на него же.
---@field use (fun(this: Obj, another: Obj): (string | boolean | nil)) Событие, которое вызывается, когда игрок пытается использовать предмет на другой предмет.
---@field used (fun(this: Obj, another: Obj): boolean?) Событие, которое вызывается, когда игрок использует другой предмет на этот. Если у другого предмета есть `use`, то оно не срабатывает.
---@field obj Obj[]
---@field state unknown Пользовательское состояние объекта. В оригинальном Instead отсутствует.
ObjArgs = {}

---@class Obj: ObjArgs
Obj = {}
---Задает список изначальных объектов как `obj`.
---@param objects (Obj | ObjId)[]
---@return Obj
function Obj:with(objects) end
---Возвращает `true` в случае, если объект закрыт.
---@return boolean
function Obj:closed() end
---Закрывает объект.
function Obj:open() end
---Возвращает объект или игрока, у которого находится данный объект.
---@return Obj | Player
function Obj:where() end
---Возвращает комнату, в которой находится объект.
---@return Room
function Obj:inroom() end
---Удалить предмет отовсюду.
function Obj:remove() end
---Возвращает `true` в случае, если объект выключен.
---@return boolean
function Obj:disabled() end
---Включает объект.
function Obj:enable() end
---Выключает объект.
function Obj:disable() end

---Итератор по объектам
---@param fn fun(obj: Obj)
function Obj:for_each(fn) end

---@param o ObjArgs
---@return Obj
function obj(o) end

---@class RoomArgs
---@field nam RoomId Идентификатор комнаты.
---@field disp string Название комнаты.
---@field dsc (string | fun(this: Room): string?) Описание комнаты, которое выводится один раз при входе или при явном осмотре комнаты. В нем нет описаний объектов, присутствующих в комнате.
---@field decor (string | fun(this: Room): string?) Декорация — постоянное описание комнаты.
---@field way RoomId[] Список комнат, в которые можно переместиться из данной комнаты.
---@field obj (Obj | ObjId)[] Изначальный список объектов.

---@class Room: RoomArgs
Room = {}
---Задает список изначальных объектов как `obj`.
---@param objects (Obj | ObjId)[]
---@return Room
function Room:with(objects) end

---@param r RoomArgs
---@return Room
function room(r) end

---Вывод строки в буфер строки с пробелом в конце.
---@param s string
function p(s) end
---Вывод строки в буфер строки "как есть".
---@param s string
function pr(s) end
---вывод строки в буфер строки с переводом строки в конце.
---@param s string
function pn(s) end

---Переместить `game.player` в указанную комнату.
---@param room (RoomId | Room)
function walk(room) end

---Текущий игрок.
---@type Player
pl = nil

---Возвращает текущего игрока. Возможно, `game.player` — это одно и то же. В доке пишут, что `me() == pl`
---@return Player
function me() end

---Переместить объект в указанную комнату/объект. Если не указана комната/объект, помещает в текущее.
---@param obj (Obj | ObjId)
---@param where (Room | Obj | ObjId)?
function place(obj, where) end

---Вернуть объект или комнату по идентификатору
---@param obj_id ObjId
---@return (Obj | Room)
function _(obj_id) end

---Создает переход.
---
---Приблизительно эквивалентно коду:
---
---```lua
---function path(args)
---  local display, where = args[1], args[2]
---  room {
---    disp = display,
---    onwalk = function ()
---      walk(where)
---    end
---  }
---end
---```
---
---## Примеры
---
---```lua
---path { ’В главную комнату’, 'main' }
---```
---
---@overload fun(args: { [1]: string, [2]: string, [3]: (RoomId | fun(): RoomId) })
---@param args ({ [1]: string, [2]: (RoomId | fun(): RoomId) })
function path(args) end

---@class DlgArgs
---@field nam string Идентификатор
---@field title string
---@field enter string
---@field phr table

---@class Dlg: DlgArgs

---@param o DlgArgs
---@return Dlg
function dlg(o) end

---пуста ли ветвь диалога? (или объект)
---@param w (Obj | Dlg)
---@return boolean
function empty(w) end
