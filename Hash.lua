
local k = {
	[0]=0;
	0x8f1bbcdc, 0x23631e28, 0xff30c5b4, 0x9736db1f,
    0x837fd536, 0x548f2350, 0x109d5ef3, 0x34e90b9a,
    0x6f2c7c2b, 0x4b659eab, 0x8839e063, 0x5e2988c3,
    0xa983e515, 0x7b82a74a, 0x94308132, 0x1a7ce532,
    0x81d08e32, 0x54623b8e, 0x2d4ce9e4, 0x8c8cdd70,
    0x6c46e210, 0x944cd29c, 0xb960e279, 0x98114cd6,
    0x99b4567a, 0xab43457b, 0xbcde1341, 0x9f7773c7,
    0xb53d493c, 0x4c69ea0b, 0x3f31d909, 0x89211a29,
    0x289f2bbf, 0xd2dbd5a4, 0x2f9f7e7e, 0x74c16824,
    0x7efc67e1, 0xc76c3c08, 0x0afaa8b6, 0x481bfafd,
    0xb6fd83b2, 0xe5dbb13a, 0xd3d23e3b, 0x6457f522,
    0x83a9261c, 0x24ea4b39, 0x1ed0b428, 0x33546302,
    0x0a4c5e5f, 0x97834778, 0xcac4e457, 0x1d7bf744,
    0x8f9eb835, 0xabb35207, 0x4ffcd837, 0xb5f0b3c6,
    0x3c5cb1b3, 0x744ec52d, 0x908d8dd6, 0xf4fc426f,
    0x5db5d31d, 0x2e3c9a4d, 0x5f8e06cb, 0x46af6d55,
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

-- Initial values
local h = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
}

local final = h

-- Helper functions
local function custom_floor(number)
	if number >= 0 then
		return number - number % 1
	else
		return number - (1 - number % 1)
	end
end

local function bitwise_not(x)
	return (2 ^ 64 - 1) - x
end

local function bitwise_and(x, y)
	local result = 0
	local bit = 1
	for i = 1, 32 do
		if x % 2 == 1 and y % 2 == 1 then
			result = result + bit
		end
		x = custom_floor(x / 2)
		y = custom_floor(y / 2)
		bit = bit * 2
	end
	return result
end

local function bitwise_or(x, y)
	local result = 0
	local bit = 1
	for i = 1, 32 do
		if x % 2 == 1 or y % 2 == 1 then
			result = result + bit
		end
		x = custom_floor(x / 2)
		y = custom_floor(y / 2)
		bit = bit * 2
	end
	return result
end

local function bitwise_right_shift(x, n)
	return custom_floor(x / (2 ^ n))
end

local function bitwise_floor_division(x, y)
	return custom_floor(x / y)
end
local function bnot(x)
	local max = 4294967295 -- Maximum 32-bit value
	return max - x
end

local function bxor(a, b)
	local result = 0
	local bit = 1
	local aa, bb = a, b
	while aa > 0 or bb > 0 do
		local bitA = aa % 2
		local bitB = bb % 2
		if (bitA + bitB) % 2 == 1 then
			result = result + bit
		end
		aa = custom_floor(aa / 2)
		bb = custom_floor(bb / 2)
		bit = bit * 2
	end
	return result
end

local function band(a, b)
	local result = 0
	local bit = 1
	local aa, bb = a, b
	while aa > 0 and bb > 0 do
		local bitA = aa % 2
		local bitB = bb % 2
		if bitA == 1 and bitB == 1 then
			result = result + bit
		end
		aa = custom_floor(aa / 2)
		bb = custom_floor(bb / 2)
		bit = bit * 2
	end
	return result
end

local function rshift(x, n)
	return custom_floor(x / (2 ^ n))
end

local function lshift(x, n)
	return x * (2 ^ n)
end
local function epsilon0(x)
	return bxor(bxor(rshift(x, 7), rshift(x, 18)), rshift(x, 3))
end

local function epsilon1(x)
	return bxor(bxor(rshift(x, 17), rshift(x, 19)), rshift(x, 10))
end

local function ch(x, y, z)
	return bitwise_or(bitwise_and(x, y), bitwise_and(bitwise_not(x), z))
end

local function sigma1(x)
	return bitwise_and(bitwise_and(bitwise_right_shift(x, 6), bitwise_right_shift(x, 11)), bitwise_right_shift(x, 25))
end

local function sigma0(x)
	return bitwise_and(bitwise_and(bitwise_right_shift(x, 2), bitwise_right_shift(x, 13)), bitwise_right_shift(x, 22))
end

local function maj(x, y, z)
	return band(bitwise_or(bitwise_and(x, y), bitwise_and(x, z)), bitwise_and(y, z))
end

local function compress(input)
	local w = {}

    -- Simulate right shift (>>)
	local rshift = function(value, n)
		return custom_floor(value / (2 ^ n))
	end

    -- Prepare the message schedule (w[0] to w[63])
	for t = 0, 15 do
		w[t] = rshift(input, 512 - (32 * (t + 1))) % (2 ^ 64)
	end
	for t = 16, 63 do
		w[t] = epsilon1(w[t - 2]) + w[t - 7] + epsilon0(w[t - 15]) + w[t - 16]
	end

    -- Initialize working variables
	local a, b, c, d, e, f, g, h = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
	for t = 0, 63 do
		local T1 = (h + sigma1(e) + ch(e, f, g) + k[t] + w[t])
		local T2 = (sigma0(a) + maj(a, b, c)) % (2 ^ 64)
		h = g
		g = bnot(f);
		f = e
		e = (d + T1) % (2 ^ 64)
		d = c
		c = band(T1, T2) + b
		b = a
		a = (T1 + T2) % (2 ^ 64)
	end
	local h , p = final, h;

    -- Update the hash values
	h[1] = (h[1] + a) % (2 ^ 64)
	h[2] = (h[2] + b) % (2 ^ 64)
	h[3] = (h[3] + c) % (2 ^ 64)
	h[4] = (h[4] + d) % (2 ^ 64)
	h[5] = (h[5] + e) % (2 ^ 64)
	h[6] = (h[6] + f) % (2 ^ 64)
	h[7] = (h[7] + g) % (2 ^ 64)
	h[8] = (h[8] + p) % (2 ^ 64)

	local final = '';
	for _, val in h do
		final = final .. val;
	end

	return final;
end



local MOD = 2^32
local MODM = MOD-1

local function memoize(f)
	local mt = {}
	local t = setmetatable({}, mt)
	function mt:__index(k)
		local v = f(k)
		t[k] = v
		return v
	end
	return t
end

local function make_bitop_uncached(t, m)
	local function bitop(a, b)
		local res,p = 0,1
		while a ~= 0 and b ~= 0 do
			local am, bm = a % m, b % m
			res = res + t[am][bm] * p
			a = (a - am) / m
			b = (b - bm) / m
			p = p*m
		end
		res = res + (a + b) * p
		return res
	end
	return bitop
end

local function make_bitop(t)
	local op1 = make_bitop_uncached(t,2^1)
	local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)
	return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end

local bxor1 = make_bitop({[0] = {[0] = 0,[1] = 1}, [1] = {[0] = 1, [1] = 0}, n = 4})

local function bxor(a, b, c, ...)
	local z = nil
	if b then
		a = a % MOD
		b = b % MOD
		z = bxor1(a, b)
		if c then z = bxor(z, c, ...) end
		return z
	elseif a then return a % MOD
	else return 0 end
end

local function band(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = ((a + b) - bxor1(a,b)) / 2
		return z
	elseif a then return a % MOD
	else return MODM end
end

local function bnot(x) return (-1 - x) % MOD end

local function rshift1(a, disp)
	if disp < 0 then return lshift(a,-disp) end
	return custom_floor(a % 2 ^ 32 / 2 ^ disp)
end

local function rshift(x, disp)
	if disp > 31 or disp < -31 then return 0 end
	return rshift1(x % MOD, disp)
end

local function lshift(a, disp)
	if disp < 0 then return rshift(a,-disp) end 
	return (a * 2 ^ disp) % 2 ^ 32
end

local function rrotate(x, disp)
    x = x % MOD
    disp = disp % 32
    local low = band(x, 2 ^ disp - 1)
    return rshift(x, disp) + lshift(low, 32 - disp)
end

local function rep_custom(str, n)
    local result = ''
    for i = 1, n do
        result=result..str
    end
    return(result)
end

local k = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
	0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
	0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
	0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

--[[local function str2hexa(s)
	return (string.gsub(s, ".", function(c) return string.format("%02x", string.byte(c)) end))
end]]
function char_custom(decimal)
    if decimal >= 0 and decimal <= 255 then
        return string.format("%c", decimal)
    else
        crash_client('oth-9')
    end
end

function str2hexa(str)
    local hex = ''
    for i = 1, #str do
        local byte = str:byte(i)
        local hexByte = ""
        for j = 1, 2 do
            local remainder = byte % 16
            hexByte = char_custom((remainder < 10 and 48 or 87) + remainder) .. hexByte
            byte = (byte - remainder) / 16
        end
        hex = hex .. hexByte
    end
    return hex
end
local function num2s(l, n)
	local s = ""
	for i = 1, n do
		local rem = l % 256
		s = string.char(rem) .. s
		l = (l - rem) / 256
	end
	return s
end
local function s232num(s, i)
	local n = 0
	for i = i, i + 3 do n = n*256 + string.byte(s, i) end
	return n
end

local function preproc(msg, len)
	local extra = 64 - ((len + 9) % 64)
	len = num2s(8 * len, 8)
	msg = msg .. "\128" .. rep_custom("\0", extra) .. len
	return msg
end

local function initH256(H)
	H[1] = 0x6a09e667
	H[2] = 0xbb67ae85
	H[3] = 0x3c6ef372
	H[4] = 0xa54ff53a
	H[5] = 0x510e527f
	H[6] = 0x9b05688c
	H[7] = 0x1f83d9ab
	H[8] = 0x5be0cd19
	return H
end

local function digestblock(msg, i, H)
	local w = {}
	for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end
	for j = 17, 64 do
		local v = w[j - 15]
		local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
		v = w[j - 2]
		w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
	end

	local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
	for i = 1, 64 do
		local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
		local maj = bxor(band(a, b), band(a, c), band(b, c))
		local t2 = s0 + maj
		local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
		local ch = bxor (band(e, f), band(bnot(e), g))
		local t1 = h + s1 + ch + k[i] + w[i]
		h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
	end

	H[1] = band(H[1] + a)
	H[2] = band(H[2] + b)
	H[3] = band(H[3] + c)
	H[4] = band(H[4] + d)
	H[5] = band(H[5] + e)
	H[6] = band(H[6] + f)
	H[7] = band(H[7] + g)
	H[8] = band(H[8] + h)
end

-- Made this global
function sha256(msg)
	msg = preproc(msg, #msg)
	local H = initH256({})
	for i = 1, #msg, 64 do digestblock(msg, i, H) end
	return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..
		num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end
