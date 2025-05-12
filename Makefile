# 定义变量
DOTFILES_DIR := $(CURDIR)
BACKUP_DIR := $(DOTFILES_DIR)/backup
HOME_DIR := $(HOME)

# dotfiles 列表 (排除 .git 、backup 以及 iTerm 配置文件)
DOTFILES := $(shell find $(DOTFILES_DIR) -maxdepth 1 -type f -name ".*" ! -path "$(DOTFILES_DIR)/.git" ! -name ".Makefile.swp" ! -name "iTerm*")

.PHONY: all backup link clean restore

# 默认目标：备份并创建符号链接
all: backup link

# 备份已有的 dotfiles
backup:
	@echo ">> 备份已存在的 dotfiles 到 $(BACKUP_DIR)..."
	@mkdir -p $(BACKUP_DIR)
	@for file in $(DOTFILES); do \
		filename=$$(basename $$file); \
		if [ -e $(HOME_DIR)/$$filename ] && [ ! -L $(HOME_DIR)/$$filename ]; then \
			echo ">> 备份: $(HOME_DIR)/$$filename -> $(BACKUP_DIR)/$$filename"; \
			cp -p $(HOME_DIR)/$$filename $(BACKUP_DIR)/$$filename; \
		fi; \
	done
	@echo ">> 备份完成！"

# 创建符号链接
link:
	@echo ">> 创建符号链接..."
	@for file in $(DOTFILES); do \
		filename=$$(basename $$file); \
		target=$(HOME_DIR)/$$filename; \
		if [ -L $$target ]; then \
			echo ">> 已存在符号链接，跳过: $$target"; \
		else \
			echo ">> 链接: $$file -> $$target"; \
			ln -sf $$file $$target; \
		fi; \
	done
	@echo ">> 符号链接创建完成！"

# 清理符号链接
clean:
	@echo ">> 删除符号链接..."
	@for file in $(DOTFILES); do \
		filename=$$(basename $$file); \
		target=$(HOME_DIR)/$$filename; \
		if [ -L $$target ]; then \
			echo ">> 删除符号链接: $$target"; \
			rm -f $$target; \
		fi; \
	done
	@echo ">> 符号链接已删除！"

# 恢复备份的文件
restore:
	@echo ">> 恢复备份的文件..."
	@for file in $(BACKUP_DIR)/*; do \
		filename=$$(basename $$file); \
		target=$(HOME_DIR)/$$filename; \
		if [ -e $$file ]; then \
			echo ">> 恢复: $$file -> $$target"; \
			cp -p $$file $$target; \
		fi; \
	done
	@echo ">> 恢复完成！"

