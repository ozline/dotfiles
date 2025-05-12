# 定义变量
DOTFILES_DIR := $(CURDIR)
BACKUP_DIR := $(DOTFILES_DIR)/backup
HOME_DIR := $(HOME)

# dotfiles 列表 (排除 .git 、backup 以及 iTerm 配置文件)
DOTFILES := $(shell find $(DOTFILES_DIR) -maxdepth 1 -name ".*" ! -path "$(DOTFILES_DIR)/.git" ! -name ".Makefile.swp" ! -name "iTerm*")

.PHONY: all backup link clean restore

# 默认目标：备份并创建符号链接
all: backup link

# 备份已有的 dotfiles
backup:
	@echo ">> 备份已存在的 dotfiles 到 $(BACKUP_DIR)..."
	@mkdir -p $(BACKUP_DIR)
	@for item in $(DOTFILES); do \
		name=$$(basename $$item); \
		target=$(HOME_DIR)/$$name; \
		if [ -e $$target ] && [ ! -L $$target ]; then \
			if [ -d $$target ]; then \
				echo ">> 备份目录: $$target -> $(BACKUP_DIR)/$$name"; \
				cp -r $$target $(BACKUP_DIR)/$$name; \
			else \
				echo ">> 备份文件: $$target -> $(BACKUP_DIR)/$$name"; \
				cp -p $$target $(BACKUP_DIR)/$$name; \
			fi; \
		fi; \
	done
	@echo ">> 备份完成！"

# 创建符号链接
link:
	@echo ">> 创建符号链接..."
	@for item in $(DOTFILES); do \
		name=$$(basename $$item); \
		target=$(HOME_DIR)/$$name; \
		if [ -L $$target ]; then \
			echo ">> 已存在符号链接，跳过: $$target"; \
		else \
			echo ">> 删除已存在的文件或目录: $$target"; \
			sudo rm -rf $$target; \
			echo ">> 链接: $$item -> $$target"; \
			ln -snf $$item $$target; \
		fi; \
	done
	@echo ">> 符号链接创建完成！"

# 清理符号链接
clean:
	@echo ">> 删除符号链接..."
	@for item in $(DOTFILES); do \
		name=$$(basename $$item); \
		target=$(HOME_DIR)/$$name; \
		if [ -L $$target ]; then \
			echo ">> 删除符号链接: $$target"; \
			rm -f $$target; \
		fi; \
	done
	@echo ">> 符号链接已删除！"

# 恢复备份的文件
restore:
	@echo ">> 恢复备份的文件和目录..."
	@for item in $(BACKUP_DIR)/*; do \
		name=$$(basename $$item); \
		target=$(HOME_DIR)/$$name; \
		if [ -e $$item ]; then \
			if [ -d $$item ]; then \
				echo ">> 恢复目录: $$item -> $$target"; \
				cp -r $$item $$target; \
			else \
				echo ">> 恢复文件: $$item -> $$target"; \
				cp -p $$item $$target; \
			fi; \
		fi; \
	done
	@echo ">> 恢复完成！"
