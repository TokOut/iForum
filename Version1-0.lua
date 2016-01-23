
--# Main

displayMode(OVERLAY)
displayMode(FULLSCREEN)
supportedOrientations(WIDTH)

function setup()
    -- Settings
    
    -- put in (nil) if its a beta test version
    forumname = "My Codea's Creation"
    -- put in (nil) if you havent a forum domain
    url = nil
    -- A random color of your forum background
    bgcolor = color(162, 222, 9, 255)
    -- The version of the Forum
    version = "1.0.4"
    -- The text color from 0 till 100 (supported)
    local z = 0
    -- Categorys
    categorys = {"General", "Questions", "Codes", "Off Topic"}
    -- Discussions
    dynamic = {}
    
    -- Data
    currentPage = AllDiscussions()
    dynamic = {DiscussionType("Road Map "..version, "General", "TokOut", currentPage.y + 170, [[This topic was created<break>to see the different positions<break>and spawning of the new Discussion.<break>They will currently spawn at bottom.]]), DiscussionType("Highlighting", "General", "TokOut", currentPage.y + 280, [[This tags: < break >, < vers >,<break>< break double >]])}
    parameter.watch("currentPage.y")
    -- Mesh
    header = mesh()
    header.vertices = {vec3(0, 650, 0), vec3(WIDTH, 650, 0), vec3(WIDTH, HEIGHT, 0)}
    header.colors =
    {color(50, 0, 255, 255), color(130, 214, 119, 255), color(255, 0, 255, 255)}
    header2 = mesh()
    header2.vertices = {vec3(0, 650, 0), vec3(WIDTH, HEIGHT, 0), vec3(0, HEIGHT, 0)}
    header2.colors = 
    {color(50, 0, 255, 255), color(255, 0, 255, 255), color(87, 46, 42, 255)}
    textcolor = color(z, z, z, 255)
    if user == nil then user = "Guest" end
end

function draw()
    background(bgcolor)
    currentPage:draw()
    header:draw()
    header2:draw()
    fill(textcolor)
    font("Arial-BoldMT")
    fontSize(60)
    if forumname == nil then forumname = "Beta Forum version" end
    text(forumname, WIDTH/2, HEIGHT - 50)
    font("ArialMT")
    fontSize(15)
    if CurrentTouched then text("Touch Radar detected touch", 100, 665) end
    if url == nil then url = "This forum is not storaged on a domain" end
    fontSize(20)
    text(url, WIDTH/2, 675)
end

function touched(t)
    currentPage:touched(t)
    if t.state == ENDED then CurrentTouched = false else CurrentTouched = true end
end

function keyboard(key)
    currentPage:keyboard(key)
end

 
--# AllDiscussions
AllDiscussions = class()
-- Nothing more the General

function AllDiscussions:init()
    self.y = 0
    self.touch = false
    self.p = 280 - #dynamic * 110
end

function AllDiscussions:addDiscussion(name, category, own, data)
    local p = self.p
    table.insert(dynamic, DiscussionType(name, category, own, p, data))
    self.p = self.p - 110
end

function AllDiscussions:draw()
    translate(0, self.y)
    self.p = 280 - #dynamic * 110
    -- Discussions/Draw them
    self.creatediscussion = CreateTopic(500)
    self.creatediscussion:draw()
    self.settings = SettingBox(390)
    self.settings:draw()
    for _,d in pairs(dynamic) do d:draw() end
    translate(0, -self.y)
end

function AllDiscussions:touched(t)
    -- Action List
    self.creatediscussion:touched(t)
    self.settings:touched(t)
    -- Main Action
    if t.state == ENDED then
        self.touch = false
        local currentY = 0
    else
        if t.y < 650 then
            self.touch = true
            local currentY = t.y
            translate(0, currentY)
            if currentY > self.y then
                self.y = self.y + t.deltaY/2
            else
                self.y = self.y - t.deltaY/2
            end
            translate(0, -currentY)
            for _,d in pairs(dynamic) do d:touched(t) end
        end
    end
end

-- This function is nil
function AllDiscussions:keyboard(key)end

--# DiscussionType
DiscussionType = class()

function DiscussionType:init(name, category, own, y, data)
    if name == nil then name = "Discussion" end
    if category == nil then category = "General" end
    if y == nil then y = 0 end
    if id == nil then id = 0 end
    if data == nil then data = "This Discussion is not existing!\nThis will be soon deleted!\nPlease dont answer to this topic if you dont want to get baned!\nPlease inform us about existing\nof this topic" end
    if own == nil then own = "No Owner" end
    self.name = name
    self.category = category
    self.y = y
    self.data = data
    self.description = string.sub(self.data, 1, 75).."..."
    self.description = self.description:gsub("<break>", "\n")
    self.owner = own
end

function DiscussionType:draw()
    fill(255, 255, 255, 255)
    strokeWidth(5)
    stroke(0, 0, 0, 255)
    rect(50, self.y, 300, 100)
    font("AmericanTypewriter-Bold")
    fontSize(20)
    fill(textcolor)
    self.w = textSize(self.name)
    text(self.name, 65 + self.w/2, self.y + 75)
    fontSize(15)
    self.w2 = textSize(self.category)
    text(self.category, 335 - self.w2/2, self.y + 75)
    font("Arial-ItalicMT")
    self.w3,self.h = textSize(self.description)
    fill(127, 127, 127, 255)
    text(self.description, 65 + self.w3/2, self.y + 60 - self.h/2)
end

function DiscussionType:touched(t)
    if t.state == BEGAN then
        if t.x>50 and t.x<350 and t.y>self.y and t.y<self.y+100 then
            currentPage = DiscussionPage(self.name, self.data)
        end
    end
end

--# DiscussionPage
DiscussionPage = class()

function DiscussionPage:init(name, data)
    self.name = name
    self.y = 0
    self.data = data
    self.input = ""
end

function DiscussionPage:draw()
    self:styling()
    fill(textcolor)
    font("Arial-BoldMT")
    fontSize(15)
    if self.touch then text("Touch Radar in activation", 100, 665) end
    fontSize(35)
    self.w = textSize(self.name)
    text(self.name, 25 + self.w/2, self.y + 600)
    fontSize(20)
    -- Text
    self.w2, self.h2 = textSize(self.data)
    font("AmericanTypewriter")
    text(self.data, 25 + self.w2/2, self.y + 550 - self.h2/2)
    -- Comments
    sprite("Cargo Bot:Goal Area", 250, self.y + 425 - self.h2, 400, 200)
    self.w3, self.h3 = textSize(self.input)
    text(self.input, 50 + self.w3/2, self.y + 500 - self.h2 - self.h3/2)
end

function DiscussionPage:touched(t)
    if t.state == ENDED then
        self.touch = false
        local currentY = 0
    else
        if t.y < 650 then
            self.touch = true
            local currentY = t.y
            translate(0, currentY)
            if currentY > self.y then
                self.y = self.y + t.deltaY/2
            else
                self.y = self.y - t.deltaY/2
            end
            translate(0, -currentY)
            --250, self.y + 425 - self.h2, 400, 200
            if t.x>50 and t.x<450 and t.y>self.y+325-self.h2 and t.y<self.y+525-self.h2 and t.state == BEGAN then
                showKeyboard()
            else
                hideKeyboard()
            end
        elseif t.state == BEGAN then currentPage = AllDiscussions() end
    end
end

function DiscussionPage:keyboard(key)
    if key == BACKSPACE then
        if string.len(self.input)>=1 then
            self.input = string.sub(self.input, 1, string.len(self.input) - 1)
        end
    elseif key == RETURN then
        hideKeyboard()
        self:post(self.input)
    else
        self.input = self.input .. key
    end
end

function DiscussionPage:post(post_data)
    self.data = self.data .. "\nComment by " .. user .. ": " .. self.input
    self.input = ""
end

function DiscussionPage:styling()
    -- Replace simple edits
    local rep = "****"
    self.data = self.data:gsub("<break double>", "\n\n     ")
    self.data = self.data:gsub("<break>", "\n     ")
    self.data = self.data:gsub("<vers>", version)
end


--# CreateTopicPage
CreateTopicPage = class()

function CreateTopicPage:init()
    self.text = {title = "Title here", message = "Message is here and\nnew line test"}
    self.buttons = {}
    self.xy = 64
    self.selected = 1
    self.category = nil
    self.y = "This Page is not scrollable"
    -- Set here
    self.letters = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","m",","," ", "!","1", "2","3","4","5","6","7", "8", "9", "0","?","RET","BCK","POST"}
end

function CreateTopicPage:draw()
    fill(textcolor)
    font("Arial-BoldMT")
    self.text.title_width,_ = textSize(self.text.title)
    text(self.text.title, 50 + self.text.title_width/2, 600)
    self.text.message_width, self.text.message_height = textSize(self.text.message)
    text(self.text.message, 50 + self.text.message_width/2, 550 - self.text.message_height/2)
    local n=0
    for y = 1, 3 do
        self.buttons[y] = {}
        for x = 1, 14 do
            n = n + 1
            strokeWidth(0)
            fill(255, 255, 255, 255)
            rect(x * self.xy, y * self.xy, self.xy, self.xy)
            fill(textcolor)
            text(self.letters[n], x * self.xy + self.xy/2, y * self.xy + self.xy/2)
        end
    end
    local c = #categorys
    local n2 = 0
    local v = true
    for y = 1, c do
        if categorys[v] then fill(0, 0, 255, 255) else fill(255, 255, 255, 255) end
        n2 = n2 + 1
        stroke(0, 0, 255, 255)
        strokeWidth(1)
        rect(750, y * 55 + 250, 200, 50)
        font("AmericanTypewriter")
        fontSize(25)
        fill(textcolor)
        text(categorys[n2], 850, y * 55 + 275)
    end
end


function CreateTopicPage:touched(t)
    local n = 0
    for y = 1, 3 do
        self.buttons[y] = {}
        for x = 1, 14 do
            n = n + 1
            if t.x>x*self.xy and t.x<x*self.xy+self.xy and t.y>y*self.xy and t.y<y*self.xy+self.xy and t.state == BEGAN then
                local y = y
                --print(x .. "," .. y)
                if x == 14 and y == 3 then
                    -- Post
                    self:post()
                elseif x == 13 and y == 3 then
                    -- Back
                    if self.selected == 1 then
                        if string.len(self.text.title)>=1 then
                            self.text.title = string.sub(self.text.title, 1, string.len(self.text.title)-1)
                        else
                            sound(DATA, "ZgJAfxI2Gz9PPzNA8kWiPa+4RD++SBQ+EQB/RUtEQEAyfQZq")
                        end
                    else
                        if string.len(self.text.message)>=1 then
                            self.text.message = string.sub(self.text.message, 1, string.len(self.text.message)-1)
                        else
                            self.selected = 1
                        end
                    end
                elseif x == 12 and y == 3 then
                    -- Return
                    if self.selected == 1 then
                        self.selected = 2
                    else
                        self.text.message = self.text.message .. "\n"
                    end
                else
                    if self.selected == 1 then
                        self.text.title = self.text.title .. self.letters[n]
                    else
                        self.text.message = self.text.message .. self.letters[n]
                    end
                end
            end
        end
    end
    local n2 = 0
    local c = #categorys
    local v = true
    for y = 1, c do
        n2 = n2 + 1
        if t.x>750 and t.x<950 and t.y> y * 55 + 250 and t.y< y * 55 + 300 and t.state == BEGAN then
            local CurrentSelected = categorys[n2]
            print(CurrentSelected)
            self.category = CurrentSelected
            if categorys[v] then categorys[v] = false else categorys[v] = true end
        end
    end
    if t.y > 650 then
        currentPage = AllDiscussions()
    end
end

function CreateTopicPage:post()
    if string.len(self.text.message)==0 or string.len(self.text.title)==0 or self.category==nil then
        print("Failed: Title, body or nil category")
        self.selected = 1
    else
        local t = self.text.title
        local b = self.text.message
        local c = self.category
        currentPage = AllDiscussions()
        currentPage:addDiscussion(t, c, "Non User", b)
    end
end

--[[
AllDiscussions:13: bad argument #1 to 'insert' (table expected, got nil)
stack traceback:
	[C]: in function 'table.insert'
	AllDiscussions:13: in method 'addDiscussion'
	CreateTopicPage:120: in method 'post'
	CreateTopicPage:61: in method 'touched'
	Main:56: in function 'touched'
]]

function CreateTopicPage:keyboard(key)
    
end

--# CreateTopic
CreateTopic = class()

function CreateTopic:init(y)
    self.y = y
end

function CreateTopic:draw()
    fill(255, 255, 255, 255)
    strokeWidth(5)
    stroke(0, 0, 0, 255)
    rect(50, self.y, 300, 100)
    fill(textcolor)
    fontSize(20)
    font("AmericanTypewriter-Bold")
    text("Create Discussion", 155, self.y + 75)
    fontSize(15)
    text("Add Topic", 300, self.y + 75)
    fontSize(20)
    font("HoeflerText-Italic")
    fill(127, 127, 127, 255)
    text("To create a topic click here", 165, self.y + 50)
end

function CreateTopic:touched(t)
    if t.state == BEGAN then
        if t.x>50 and t.x<350 and t.y>self.y and t.y<self.y+100 then
            currentPage = CreateTopicPage()
        end
    end
end

--# SettingBox
SettingBox = class()

function SettingBox:init(y)
    self.y = y
end

function SettingBox:draw()
    fill(255, 255, 255, 255)
    strokeWidth(5)
    stroke(0, 0, 0, 255)
    rect(50, self.y, 300, 100)
    fill(textcolor)
    fontSize(20)
    font("AmericanTypewriter-Bold")
    text("Settings", 110, self.y + 75)
    fontSize(15)
    text("Important", 295, self.y + 75)
end

function SettingBox:touched(t)
    if t.y < 650 and t.state == ENDED then
        if t.x>50 and t.x<350 and t.y>self.y and t.y<self.y+100 then
            currentPage = Settings()
        end
    end
end

--# Settings

Settings = class()

function Settings:init()
    self.y = 0
    self.touch = false
    self.x = {a = bgcolor.r, b = bgcolor.g, c = bgcolor.b, d = textcolor.r, e = textcolor.g, f = textcolor.b}
end

function Settings:draw()
    font("Arial-BoldMT")
    fontSize(20)
    fill(textcolor)
    text("Background color", 125, self.y + 625)
    text("Text color", 85, self.y + 400)
    stroke(65, 255)
    strokeWidth(5)
    line(50, self.y + 550, 510, self.y + 550)
    line(50, self.y + 500, 510, self.y + 500)
    line(50, self.y + 450, 510, self.y + 450)
    line(50, self.y + 325, 510, self.y + 325)
    line(50, self.y + 275, 510, self.y + 275)
    line(50, self.y + 225, 510, self.y + 225)
    strokeWidth(2)
    fill(255, 255, 0, 255)
    stroke(255, 146, 0, 255)
    ellipse(self.x.a * 2 + 50, self.y + 550, 25)
    ellipse(self.x.b * 2 + 50, self.y + 500, 25)
    ellipse(self.x.c * 2 + 50, self.y + 450, 25)
    ellipse(self.x.d * 2 + 50, self.y + 325, 25)
    ellipse(self.x.e * 2 + 50, self.y + 275, 25)
    ellipse(self.x.f * 2 + 50, self.y + 225, 25)
    fill(textcolor)
    text("Red " .. self.x.a, 575, self.y + 550)
    text("Green " .. self.x.b, 575, self.y + 500)
    text("Blue " .. self.x.c, 575, self.y + 450)
    -- Set values to this parameters
    bgcolor.r = self.x.a
    bgcolor.g = self.x.b
    bgcolor.b = self.x.c
    textcolor.r = self.x.d
    textcolor.g = self.x.e
    textcolor.b = self.x.f
end

function Settings:touched(t)
    if t.y < 650 then
        if t.state == ENDED then
            self.touch = false
        else
            self.touch = true
            --self.y = self.y + t.deltaY/2
            if t.x>50 and t.x<550 and t.y>540 and t.y<560 and self.x.a>=-25 and self.x.a<=300 then
                self.x.a = self.x.a + t.deltaX/5
            elseif t.x>50 and t.y>490 and t.x<550 and t.y<510 and self.x.b>=-25 and self.x.b<=300 then
                self.x.b = self.x.b + t.deltaX/5
            elseif t.x>50 and t.x<550 and t.y>440 and t.y<460 and self.x.c>=-25 and self.x.c<=300 then
                self.x.c = self.x.c + t.deltaX/5
            end
        end
    elseif t.state == BEGAN then
        currentPage = AllDiscussions()
    end
end

-- Nil function
function Settings:keyboard(key) end
